import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

/***
 1,1  2,1  3,1  4,1  5,1
 1,2  2,2  3,2  4,2  5,2
 1,3  2,3  3,3  4,3  5,3
 1,4  2,4  3,4  4,4  5,4
 1,5  2,5  3,5  4,5  5,5
 - The first number in each pair represents the x-coordinate (horizontal position from the left edge).
 - The second number represents the y-coordinate (vertical position from the top edge).
 * Transformations: If you rotate an image or apply other transformations, 
   the coordinates of each pixel change. For instance, 
   if you rotate the image 90 degrees clockwise, 
   our original top-left pixel (1,1) moves to a new position (5,1).

 */

/**
 * These transformations ensure that the coordinates from an image are accurately translated 
   to a different coordinate system (like a canvas on a device screen), 
   considering the orientation and camera used. 
 */
double translateX(
  // The original x-coordinate from the image.
  // The x coordinate extends from left to right
  // define the position of a point within that image's frame.
  // The coordinate system typically used in computer graphics and
  // image processing places the origin (0, 0) at the top-left corner of the image
  double x,
  // The size of the canvas (or screen) on which the image is being drawn.
  Size canvasSize,
  Size imageSize,
  // The rotation of the image as captured from the camera, indipendent from device's rotation
  // 是照片的转动方向
  InputImageRotation rotation,
  // front or back, 镜头的方向
  CameraLensDirection cameraLensDirection,
) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      // If the image is rotated 90 degrees:
      // The new x-coordinate is calculated by multiplying the original x-coordinate by the ratio
      // of the canvas width to the image height (note the width and height are swapped due to rotation).
      return x *
          canvasSize.width /
          (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation270deg:
      return canvasSize.width -
          x *
              canvasSize.width /
              (Platform.isIOS ? imageSize.width : imageSize.height);
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

double translateY(
  // The original y-coorinate from the image
  // The y coordinate extends upward.
  double y,
  Size canvasSize,
  Size imageSize,
  InputImageRotation rotation,
  CameraLensDirection cameraLensDirection,
) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return y *
          canvasSize.height /
          (Platform.isIOS ? imageSize.height : imageSize.width);
    case InputImageRotation.rotation0deg:
    case InputImageRotation.rotation180deg:
      return y * canvasSize.height / imageSize.height;
  }
}
