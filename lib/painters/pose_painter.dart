import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'coordinates_translator.dart';

// Custom painter to draw pose landmarks and connections on the canvas
class PosePainter extends CustomPainter {
  PosePainter(
      this.poses,
      this.imageSize,
      this.rotation,
      this.cameraLensDirection,
      );

  final List<Pose> poses; // List of detected poses
  final Size imageSize; // Size of the image from the camera
  final InputImageRotation rotation; // Rotation of the input image
  final CameraLensDirection cameraLensDirection; // Direction of the camera lens

  @override
  void paint(Canvas canvas, Size size) {
    // Define paint styles for different parts of the body
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.green;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    // Map of connections with corresponding paints
    final Map<Pair<PoseLandmarkType, PoseLandmarkType>, Paint> connections = {
      Pair(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow): leftPaint,
      Pair(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist): leftPaint,
      Pair(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow): rightPaint,
      Pair(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist): rightPaint,
      Pair(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip): leftPaint,
      Pair(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip): rightPaint,
      Pair(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee): leftPaint,
      Pair(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle): leftPaint,
      Pair(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee): rightPaint,
      Pair(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle): rightPaint,
    };

    // Iterate through each pose and draw the landmarks and connections
    for (final pose in poses) {
      // Draw each landmark
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
          Offset(
            translateX(
              landmark.x,
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ),
            translateY(
              landmark.y,
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ),
          ),
          1,
          basePaint,
        );
      });

      // Draw lines between connected landmarks
      connections.forEach((connection, paint) {
        final joint1 = pose.landmarks[connection.first];
        final joint2 = pose.landmarks[connection.second];
        if (joint1 != null && joint2 != null) {
          canvas.drawLine(
            Offset(
              translateX(joint1.x, size, imageSize, rotation, cameraLensDirection),
              translateY(joint1.y, size, imageSize, rotation, cameraLensDirection),
            ),
            Offset(
              translateX(joint2.x, size, imageSize, rotation, cameraLensDirection),
              translateY(joint2.y, size, imageSize, rotation, cameraLensDirection),
            ),
            paint,
          );
        }
      });
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    // Repaint only if the image size or poses have changed
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}

// Helper class to handle pairs of landmark types
class Pair<T, U> {
  final T first;
  final U second;

  Pair(this.first, this.second);
}
