import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:exercisecoach/models/push_up_model.dart';
import 'package:exercisecoach/models/squat_model.dart';
import 'package:exercisecoach/painters/pose_painter.dart';
import 'package:exercisecoach/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Stateful widget to manage the camera view and pose detection
class CameraView extends StatefulWidget {
  CameraView({
    Key? key,
    required this.customPaint,
    required this.onImage,
    required this.posePainter,
    this.onCameraFeedReady,
    this.onDetectorViewModeChanged,
    this.onCameraLensDirectionChanged,
    this.initialCameraLensDirection = CameraLensDirection.back,
  }) : super(key: key);

  final PosePainter? posePainter; // Painter for drawing poses on the canvas
  final CustomPaint? customPaint; // Custom painter for additional drawing
  final Function(InputImage inputImage) onImage; // Callback for processing images
  final VoidCallback? onCameraFeedReady; // Callback when the camera feed is ready
  final VoidCallback? onDetectorViewModeChanged; // Callback for changing detection modes
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged; // Callback for changing camera lens direction
  final CameraLensDirection initialCameraLensDirection; // Initial camera lens direction

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  static List<CameraDescription> _cameras = []; // List of available cameras
  CameraController? _controller; // Camera controller for managing camera operations
  int _cameraIndex = -1; // Index of the selected camera
  double _currentZoomLevel = 1.0; // Current zoom level
  double _minAvailableZoom = 1.0; // Minimum zoom level available
  double _maxAvailableZoom = 1.0; // Maximum zoom level available
  double _minAvailableExposureOffset = 0.0; // Minimum exposure offset
  double _maxAvailableExposureOffset = 0.0; // Maximum exposure offset
  double _currentExposureOffset = 0.0; // Current exposure offset
  bool _changingCameraLens = false; // Flag to indicate if the camera lens is being changed

  PoseLandmark? p1; // Pose landmark for the right shoulder
  PoseLandmark? p2; // Pose landmark for the right elbow
  PoseLandmark? p3; // Pose landmark for the right wrist

  PoseLandmark? k1; // Pose landmark for the right hip
  PoseLandmark? k2; // Pose landmark for the right knee
  PoseLandmark? k3; // Pose landmark for the right ankle

  String detectedExercise = 'None'; // Currently detected exercise
  String feedbackMessage = ''; // Feedback message for the user

  FlutterTts flutterTts = FlutterTts(); // Text-to-Speech instance

  @override
  void initState() {
    super.initState();
    _initialize(); // Initialize the camera and other components
    _initializeTts(); // Initialize Text-to-Speech
  }

  // Initialize Text-to-Speech settings
  void _initializeTts() {
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5);
    print('TTS Initialized');
  }

  // Function to speak a given message
  void _speak(String message) async {
    await flutterTts.stop(); // Stop any ongoing TTS
    await flutterTts.speak(message); // Speak the new message
    print('TTS Speaking: $message');
  }

  // Initialize the camera
  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
      print('Cameras initialized: ${_cameras.length} available');
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        print('Selected camera index: $_cameraIndex');
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  void didUpdateWidget(covariant CameraView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.customPaint != oldWidget.customPaint) {
      if (widget.customPaint == null) return;
      final pushUpBloc = BlocProvider.of<PushUpCounter>(context);
      final squatBloc = BlocProvider.of<SquatCounter>(context);

      for (final pose in widget.posePainter!.poses) {
        // Extract landmarks for push-ups and squats
        p1 = pose.landmarks[PoseLandmarkType.rightShoulder];
        p2 = pose.landmarks[PoseLandmarkType.rightElbow];
        p3 = pose.landmarks[PoseLandmarkType.rightWrist];
        k1 = pose.landmarks[PoseLandmarkType.rightHip];
        k2 = pose.landmarks[PoseLandmarkType.rightKnee];
        k3 = pose.landmarks[PoseLandmarkType.rightAnkle];

        // Detect and handle push-ups
        if (p1 != null && p2 != null && p3 != null) {
          double elbowAngle = utils.angle(p1!, p2!, p3!);
          print('Detected elbow angle for push-up: $elbowAngle');
          PushUpState? pushUpState = utils.isPushUp(elbowAngle, pushUpBloc.state);
          if (pushUpState != null) {
            if (pushUpState == PushUpState.complete) {
              pushUpBloc.increment();
              print('Push-up count incremented: ${pushUpBloc.counter}');
              pushUpBloc.setPushUpState(PushUpState.neutral); // Reset state
              feedbackMessage = 'Good job! Keep going!';
              _speak('${pushUpBloc.counter}'); // Speak the counter
            } else {
              pushUpBloc.setPushUpState(pushUpState);
              feedbackMessage = elbowAngle < 90 ? 'Lower your body more!' : 'Push up now!';
            }
            setState(() {
              detectedExercise = 'Push-Up';
              feedbackMessage = feedbackMessage;
            });
            continue; // Skip squat detection if push-up is detected
          }
        }

        // Detect and handle squats
        if (k1 != null && k2 != null && k3 != null) {
          double kneeAngle = utils.angle(k1!, k2!, k3!);
          print('Detected knee angle for squat: $kneeAngle');
          SquatState? squatState = utils.isSquat(kneeAngle, squatBloc.state);
          if (squatState != null) {
            print('Squat state: $squatState, Knee angle: $kneeAngle'); // Debug output
            if (squatState == SquatState.stand) {
              squatBloc.increment();
              print('Squat count incremented: ${squatBloc.counter}');
              squatBloc.setSquatState(SquatState.stand); // Reset state
              feedbackMessage = 'Well done! Stand up straight!';
              _speak('${squatBloc.counter}'); // Speak the counter
            } else {
              squatBloc.setSquatState(squatState);
              feedbackMessage = kneeAngle < 90 ? 'Go lower!' : 'Stand up now!';
            }
            setState(() {
              detectedExercise = 'Squat';
              feedbackMessage = feedbackMessage;
            });
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    flutterTts.stop();
    super.dispose();
    print('Disposed CameraView');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showConfirmationDialog();
        return false;
      },
      child: Scaffold(
        body: _liveFeedBody(),
      ),
    );
  }

  // Build the live feed body
  Widget _liveFeedBody() {
    if (_cameras.isEmpty) return Container();
    if (_controller == null) return Container();
    if (_controller?.value.isInitialized == false) return Container();
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: _changingCameraLens
                ? const Center(
              child: Text('Changing camera lens'),
            )
                : CameraPreview(
              _controller!,
              child: widget.customPaint,
            ),
          ),
          _currentExerciseWidget(),
          _feedbackWidget(),
          _endSessionButton(),
          _switchLiveCameraToggle(),
          _detectionViewModeToggle(),
          _zoomControl(),
          _exposureControl(),
        ],
      ),
    );
  }

  // Widget to display feedback message
  Widget _feedbackWidget() {
    print('Displaying feedback: $feedbackMessage');
    return Positioned(
        bottom: 100,
        left: 0,
        right: 0,
        child: Container(
        padding: const EdgeInsets.all(10),
          color: Colors.black54,
          child: Text(
            feedbackMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
    );
  }

  // Widget to display the current exercise and counter
  Widget _currentExerciseWidget() {
    final pushUpBloc = BlocProvider.of<PushUpCounter>(context);
    final squatBloc = BlocProvider.of<SquatCounter>(context);

    String counter = '';
    Color color = Colors.black54;

    if (detectedExercise == 'Push-Up') {
      counter = '${pushUpBloc.counter}';
      color = Colors.green;
    } else if (detectedExercise == 'Squat') {
      counter = '${squatBloc.counter}';
      color = Colors.green;
    }

    print('Displaying exercise: $detectedExercise with counter: $counter');

    // Displays the textbox header for counting the exercise
    return Positioned(
      left: 0,
      top: 40,
      right: 0,
      child: Container(
        width: 70,
        child: Column(
          children: [
            Text(
              '$detectedExercise ',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Container(
              width: 70,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: color, width: 4.0),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Text(
                counter,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display the detected exercise name
  Widget _exerciseNameWidget() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.black54,
        child: Text(
          'Detected Exercise: $detectedExercise',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  // Widget for the "End Session" button
  Widget _endSessionButton() => Positioned(
    bottom: 8,
    left: 0,
    right: 0,
    child: SizedBox(
      height: 50.0,
      width: 210.0,
      child: FloatingActionButton.extended(
        onPressed: () {
          _showConfirmationDialog();
        },
        backgroundColor: Colors.redAccent,
        label: Text(
          'End Session',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        icon: Icon(
          Icons.stop,
          size: 20,
        ),
      ),
    ),
  );

  Widget _detectionViewModeToggle() => Positioned(
    bottom: 8,
    left: 8,
    child: SizedBox(
      height: 50.0,
      width: 50.0,
      /*child: FloatingActionButton(
            heroTag: Object(),
            onPressed: widget.onDetectorViewModeChanged,
            backgroundColor: Colors.black54,
            child: Icon(
              Icons.photo_library_outlined,
              size: 25,
            ),
          ),*/
    ),
  );

  // Widget to switch the live camera toggle
  Widget _switchLiveCameraToggle() => Positioned(
    bottom: 60,
    right: 8,
    child: SizedBox(
      height: 50.0,
      width: 50.0,
      child: FloatingActionButton(
        heroTag: Object(),
        onPressed: _switchLiveCamera,
        backgroundColor: Colors.black54,
        child: Icon(
          Platform.isIOS
              ? Icons.flip_camera_ios_outlined
              : Icons.flip_camera_android_outlined,
          size: 25,
        ),
      ),
    ),
  );

  // Widget to control the zoom level of the camera
  Widget _zoomControl() => Positioned(
    bottom: 60,
    left: 0,
    right: 0,
    child: Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Slider(
                value: _currentZoomLevel,
                min: _minAvailableZoom,
                max: _maxAvailableZoom,
                activeColor: Colors.white,
                inactiveColor: Colors.white30,
                onChanged: (value) async {
                  setState(() {
                    _currentZoomLevel = value;
                  });
                  await _controller?.setZoomLevel(value);
                  print('Zoom level changed to: $value');
                },
              ),
            ),
            Container(
              width: 50,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '${_currentZoomLevel.toStringAsFixed(1)}x',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  // Widget to control the exposure of the camera
  Widget _exposureControl() => Positioned(
    top: 40,
    right: 8,
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 250,
      ),
      child: Column(
        children: [
          Container(
            width: 55,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  '${_currentExposureOffset.toStringAsFixed(1)}x',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: RotatedBox(
              quarterTurns: 3,
              child: SizedBox(
                height: 30,
                child: Slider(
                  value: _currentExposureOffset,
                  min: _minAvailableExposureOffset,
                  max: _maxAvailableExposureOffset,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white30,
                  onChanged: (value) async {
                    setState(() {
                      _currentExposureOffset = value;
                    });
                    await _controller?.setExposureOffset(value);
                    print('Exposure offset changed to: $value');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  // Start the live camera feed
  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup:
      Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        _currentZoomLevel = value;
        _minAvailableZoom = value;
        print('Min zoom level: $value');
      });
      _controller?.getMaxZoomLevel().then((value) {
        _maxAvailableZoom = value;
        print('Max zoom level: $value');
      });
      _currentExposureOffset = 0.0;
      _controller?.getMinExposureOffset().then((value) {
        _minAvailableExposureOffset = value;
        print('Min exposure offset: $value');
      });
      _controller?.getMaxExposureOffset().then((value) {
        _maxAvailableExposureOffset = value;
        print('Max exposure offset: $value');
      });
      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
        print('Camera feed started');
      });
      setState(() {});
    });
  }

  // Stop the live camera feed
  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
    print('Camera feed stopped');
  }

  // Switch between the front and back camera
  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;

    print('Switching camera lens to index: $_cameraIndex');
    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  // Process the camera image to detect poses
  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    widget.onImage(inputImage);
    print('Processing camera image');
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  // Convert the camera image to an InputImage for pose detection
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    print('Converted camera image to InputImage');

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  // Show a confirmation dialog to the user
  void _showConfirmationDialog() {
    final pushUpBloc = BlocProvider.of<PushUpCounter>(context);
    final squatBloc = BlocProvider.of<SquatCounter>(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you done?'),
          content: Text(
              'You have done ${pushUpBloc.counter} push-ups and ${squatBloc.counter} squats.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _showSummaryDialog(pushUpBloc.counter, squatBloc.counter);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
    print('Confirmation dialog shown');
  }

  // Show a summary dialog with the user's exercise performance
  void _showSummaryDialog(int pushUpCount, int squatCount) {
    String summary =
        'You have done $pushUpCount push-ups and $squatCount squats.';
    String motivationalMessage = '';

    if (squatCount < 5 && pushUpCount < 5) {
      motivationalMessage =
      ' Try to do more squats and push-ups next time! Remember, consistency is key and each exercise brings you closer to your fitness goals.';
    } else if (squatCount < 5) {
      motivationalMessage =
      ' Try to do more squats next time! Remember, consistency is key and each squat brings you closer to your fitness goals.';
    } else if (pushUpCount < 5) {
      motivationalMessage =
      ' Try to do more push-ups next time! Every push-up helps you build strength and endurance.';
    }

    summary += motivationalMessage;

    _speak(summary); // Use TTS to speak the summary
    print('Summary dialog shown with message: $summary');

    // Call exampleUsage to print Precision, Recall, and F1 Score
    exampleUsage();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Summary'),
          content: Text(summary),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the summary dialog
                Navigator.of(context).pop(); // Return to the previous page
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

// Method to calculate precision
  double calculatePrecision(int truePositives, int falsePositives) {
    return truePositives / (truePositives + falsePositives);
  }

  // Method to calculate recall
  double calculateRecall(int truePositives, int falseNegatives) {
    return truePositives / (truePositives + falseNegatives);
  }

  // Method to calculate F1 score
  double calculateF1Score(int truePositives, int falsePositives, int falseNegatives) {
    final precision = calculatePrecision(truePositives, falsePositives);
    final recall = calculateRecall(truePositives, falseNegatives);
    return 2 * (precision * recall) / (precision + recall);
  }

  // Example usage
  void exampleUsage() {
    final truePositives = 14;
    final falsePositives = 9;
    final falseNegatives = 1;

    final precision = calculatePrecision(truePositives, falsePositives);
    final recall = calculateRecall(truePositives, falseNegatives);
    final f1Score = calculateF1Score(truePositives, falsePositives, falseNegatives);

    print('Precision: $precision');
    print('Recall: $recall');
    print('F1 Score: $f1Score');
  }
}


