// import 'package:app/screen/google_ml_kit_pages/camera_view.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// enum DetectorViewMode { liveFeed, gallery }

// class DetectorView extends StatefulWidget {
//   final String title;
//   final CustomPaint? customPaint;
//   final String? text;
//   final int? facesDetected;
//   final DetectorViewMode initialDetectionMode;
//   final Function(InputImage inputImage) onImage;
//   final Function()? onCameraFeedReady;
//   final Function(DetectorViewMode mode)? onDetectorViewModeChanged;
//   final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
//   CameraLensDirection initialCameraLensDirection;

//   DetectorView(
//       {super.key,
//       required this.title,
//       required this.onImage,
//       this.customPaint,
//       this.text,
//       this.facesDetected,
//       this.initialDetectionMode = DetectorViewMode.liveFeed,
//       this.initialCameraLensDirection = CameraLensDirection.back,
//       this.onCameraFeedReady,
//       this.onDetectorViewModeChanged,
//       this.onCameraLensDirectionChanged});

//   @override
//   State<DetectorView> createState() => _DetectorViewState();
// }

// class _DetectorViewState extends State<DetectorView> {
//   // enum of the class, two mode.
//   late DetectorViewMode _mode;

//   @override
//   void initState() {
//     // TODO: implement initState
//     _mode = widget.initialDetectionMode;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CameraView(
//       customPaint: widget.customPaint,
//       onImage: widget.onImage,
//       onCameraFeedReady: widget.onCameraFeedReady,
//       onDetectorViewModeChanged: _onDetectorViewModeChanged,
//       initialCameraLensDirection: widget.initialCameraLensDirection,
//       onCameraLensDirectionChanged: widget.onCameraLensDirectionChanged,
//     );
//   }

//   void _onDetectorViewModeChanged() {
//     if (_mode == DetectorViewMode.liveFeed) {
//       _mode = DetectorViewMode.gallery;
//     } else {
//       _mode = DetectorViewMode.liveFeed;
//     }
//     if (widget.onDetectorViewModeChanged != null) {
//       widget.onDetectorViewModeChanged!(_mode);
//     }
//     setState(() {});
//   }
// }
