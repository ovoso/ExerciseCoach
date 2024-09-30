import 'dart:io';
import 'dart:math' as math;
import 'package:exercisecoach/models/push_up_model.dart';
import 'package:exercisecoach/models/squat_model.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getAssetPath(String asset) async {
  final path = await getLocalPath(asset);
  await Directory(dirname(path)).create(recursive: true);
  final file = File(path);
  if (!await file.exists()) {
    final byteData = await rootBundle.load(asset);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
  return file.path;
}

Future<String> getLocalPath(String path) async {
  return '${(await getApplicationSupportDirectory()).path}/$path';
}

// Calculate the angle between three landmarks
double angle(PoseLandmark firstLandmark, PoseLandmark midLandmark, PoseLandmark lastLandmark) {
  final radians = math.atan2(lastLandmark.y - midLandmark.y, lastLandmark.x - midLandmark.x) -
      math.atan2(firstLandmark.y - midLandmark.y, firstLandmark.x - midLandmark.x);
  double degrees = radians * 180.0 / math.pi;
  degrees = degrees.abs(); // Angle should never be negative
  if (degrees > 180.0) {
    degrees = 360.0 - degrees; // Always get the acute representation of the angle
  }
  return degrees;
}

// Calculate the Euclidean distance between two landmarks
double distance(PoseLandmark point1, PoseLandmark point2) {
  return math.sqrt(math.pow(point2.x - point1.x, 2) + math.pow(point2.y - point1.y, 2));
}

// Detect push-ups based on elbow angle and current state
PushUpState? isPushUp(double angleElbow, PushUpState current) {
  const umbralElbow = 60.0;
  const umbralElbowExt = 160.0;

  if (current == PushUpState.neutral && angleElbow > umbralElbowExt && angleElbow < 180.0) {
    return PushUpState.init;
  } else if (current == PushUpState.init && angleElbow < umbralElbow && angleElbow > 40.0) {
    return PushUpState.complete;
  }
  return null;
}

// Detect squats based on knee angle and current state
SquatState? isSquat(double angle, SquatState currentState) {
  const double downThreshold = 90.0; // When knee is bent
  const double standThreshold = 170.0; // When standing

  if (currentState == SquatState.stand && angle < downThreshold) {
    return SquatState.down;
  } else if (currentState == SquatState.down && angle > standThreshold) {
    return SquatState.stand;
  }
  return null; // No state change
}
