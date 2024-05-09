import 'package:app/screen/detector_view.dart';
import 'package:app/service/painter/face_detector_painter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({super.key});

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  // face detector that detects faces in a given InputImage.
  // configured to detect contours and landmarks of faces.
  final FaceDetector _faceDetector = FaceDetector(
      options:
          // Contours (轮廓)
          FaceDetectorOptions(
              enableContours: true,
              // LandMark是看见脸的时候的那些点
              enableLandmarks: true));
  bool _canProcess = true;
  bool _isBusy = false;
  // 为了在脸旁边画出方宽
  CustomPaint? _customPaint;
  String? _text;
  // 前置摄像头/后置摄像头
  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() {
    // TODO: implement dispose
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    // these 2 if prevents the function from running
    // when the system is not ready to process new images
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    // detect faces in the provided image. The result is a list of Face objects stored in faces.
    final faces = await _faceDetector.processImage(inputImage);
    print("The faces that has been detected: ${faces}");
    if (faces.isNotEmpty) {
      print(
          "all the property of first Face: BoundingBox: ${faces[0].boundingBox},AngleX: ${faces[0].headEulerAngleX}, Landmarks: ${faces[0].landmarks}, TrackingId: ${faces[0].trackingId}");
    }
    // if the data are available,
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      // Creates a FaceDetectorPainter.
      // This painter is used to draw the detected faces on a CustomPaint
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      // If either size or rotation is null, it sets _customPaint to null,
      // which likely means no drawing will occur.
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
