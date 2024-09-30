import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../painters/pose_painter.dart';
import 'detector_view.dart';

// Stateful widget that manages the pose detection view
class PoseDetectorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  // Instance of the pose detector
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true; // Flag to control processing state
  bool _isBusy = false;    // Flag to prevent multiple simultaneous processes
  CustomPaint? _customPaint; // Custom painter to draw detected poses
  String? _text;            // Text to display detection results
  PosePainter? _posePainter; // Painter for rendering poses
  var _cameraLensDirection = CameraLensDirection.back; // Direction of the camera lens

  @override
  void dispose() async {
    _canProcess = false;
    // Close the pose detector to release resources
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      // Integrates the pose painter with the detector view
      posePainter: _posePainter,
      title: 'Pose Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  // Processes the input image to detect poses
  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return; // Check if processing is allowed
    if (_isBusy) return;      // Check if a process is already running
    _isBusy = true;
    setState(() {
      _text = '';
    });

    // Detect poses in the image
    final poses = await _poseDetector.processImage(inputImage);

    // Check if image metadata is available for rendering
    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter); // Create custom painter with detected poses
      _posePainter = painter; // Set the pose painter
    } else {
      _text = 'Poses found: ${poses.length}\n\n';
      // TODO: set _customPaint to draw landmarks on top of image
      _customPaint = null;
    }

    _isBusy = false;
    if (mounted) {
      setState(() {}); // Update the state to reflect changes
    }
  }
}
