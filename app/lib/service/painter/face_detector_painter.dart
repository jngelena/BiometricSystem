import 'dart:math';

import 'package:app/service/painter/coordinates_translator.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/**
 * manages drawing detected facial features onto a canvas, 
 * considering factors such as image size, rotation, and camera lens direction
 * CustomPainter: a custom painter class in Flutter used for painting onto a canvas.
 */
class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(
      this.faces, this.imageSize, this.rotation, this.cameraLensDirection);

  // A list of detected faces.
  final List<Face> faces;
  // The size of the image in which faces are detected.
  final Size imageSize;
  // The rotation of the image (from camera sensor).
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    // ".." called a cascade operator. It allows you to perform a sequence of operations
    // on the same object without repeating the object's name.
    final Paint paint1 = Paint()
      // The paint will be applied as an outline (stroke) rather than filling the shape
      ..style = PaintingStyle.stroke
      // Sets the thickness of the line.
      ..strokeWidth = 1.0
      ..color = Colors.red;
    final Paint paint2 = Paint()
      // fill the shape
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..color = Colors.green;

    for (final Face face in faces) {
      // It calculates the bounding box for each face
      // by translating the coordinates from the image's scale to the canvas's scale
      final left = translateX(
        face.boundingBox.left,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final top = translateY(
        face.boundingBox.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final right = translateX(
        face.boundingBox.right,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final bottom = translateY(
        face.boundingBox.bottom,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      // uses these translated coordinates to draw the rectangle on the canvas.
      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint1,
      );

      // helper function is used to draw specific facial contours
      // (like the outline of the face, lips, etc.):
      void paintContour(FaceContourType type) {
        // It checks if there are points defined for the specified contour type.
        final contour = face.contours[type];
        if (contour?.points != null) {
          for (final Point point in contour!.points) {
            // Each point of the contour is drawn
            // as a small circle on the canvas at the translated coordinates.
            canvas.drawCircle(
                Offset(
                  translateX(
                    point.x.toDouble(),
                    size,
                    imageSize,
                    rotation,
                    cameraLensDirection,
                  ),
                  translateY(
                    point.y.toDouble(),
                    size,
                    imageSize,
                    rotation,
                    cameraLensDirection,
                  ),
                ),
                1,
                paint1);
          }
        }
      }

      void paintLandmark(FaceLandmarkType type) {
        final landmark = face.landmarks[type];
        if (landmark?.position != null) {
          canvas.drawCircle(
              Offset(
                translateX(
                  landmark!.position.x.toDouble(),
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  landmark.position.y.toDouble(),
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
              ),
              2,
              paint2);
        }
      }

      for (final type in FaceContourType.values) {
        paintContour(type);
      }

      for (final type in FaceLandmarkType.values) {
        paintLandmark(type);
      }
    }
  }

  // This method determines whether the canvas should be repainted.
  // It returns true if the image size or the faces have changed,
  // triggering a repaint of the widget.
  // it takes input the same Class FaceDetectorPainter
  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}
