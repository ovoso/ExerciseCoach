import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

// Function to translate the x-coordinate of a point from the image coordinate system to the canvas coordinate system
double translateX(
    double x,                    // x-coordinate in the image coordinate system
    Size canvasSize,             // Size of the canvas
    Size imageSize,              // Size of the image
    InputImageRotation rotation, // Rotation applied to the input image
    CameraLensDirection cameraLensDirection, // Direction of the camera lens (front or back)
    ) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return x * canvasSize.width / (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation270deg:
      return canvasSize.width - x * canvasSize.width / (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation0deg:
    case InputImageRotation.rotation180deg:
      switch (cameraLensDirection) {
        case CameraLensDirection.back:
          return x * canvasSize.width / imageSize.width;
        default:
          return canvasSize.width - x * canvasSize.width / imageSize.width;
      }
  }
}

// Function to translate the y-coordinate of a point from the image coordinate system to the canvas coordinate system
double translateY(
    double y,                    // y-coordinate in the image coordinate system
    Size canvasSize,             // Size of the canvas
    Size imageSize,              // Size of the image
    InputImageRotation rotation, // Rotation applied to the input image
    CameraLensDirection cameraLensDirection, // Direction of the camera lens (front or back)
    ) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return y * canvasSize.height / (Platform.isIOS ? imageSize.height : imageSize.width);
    case InputImageRotation.rotation0deg:
    case InputImageRotation.rotation180deg:
      return y * canvasSize.height / imageSize.height;
  }
}
