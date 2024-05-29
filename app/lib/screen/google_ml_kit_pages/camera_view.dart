// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_mlkit_commons/google_mlkit_commons.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// class CameraView extends StatefulWidget {
//   final CustomPaint? customPaint;
//   final Function(InputImage inputImage) onImage;
//   // a function that will be passed as an argument to another
//   // function or method. it allows the receving function
//   // to execute the callback function at a specific point int it's code
//   // Callbacks are widely used in event-driven programming,
//   // where asynchronous events trigger the execution of particular functions
//   final VoidCallback? onCameraFeedReady;
//   // VoidCallback: does not take any parameters or return a value.
//   // It allows developers to perform actions without any data input or result output,
//   // making it ideal for scenarios where a simple operation needs to be performed,
//   // such as updating UI elements or changing the application state
//   final VoidCallback? onDetectorViewModeChanged;
//   final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
//   final CameraLensDirection initialCameraLensDirection;

//   CameraView(
//       {super.key,
//       required this.customPaint,
//       required this.onImage,
//       this.onCameraFeedReady,
//       this.onDetectorViewModeChanged,
//       this.onCameraLensDirectionChanged,
//       this.initialCameraLensDirection = CameraLensDirection.back});

//   @override
//   State<CameraView> createState() => _CameraViewState();
// }

// class _CameraViewState extends State<CameraView> {
//   // avaliable cameras on the device
//   static List<CameraDescription> _cameras = [];
//   // Manages the camera's state and interaction, like starting and stopping the camera.
//   CameraController? _controller;
//   // index of selected camera
//   int _cameraIndex = -1;
//   // variables for manage the camera's zoom level
//   double _currentZoomLevel = 1.0;
//   double _minAvailableZoom = 1.0;
//   double _maxAvailableZoom = 1.0;
//   // Variables for managing the camera's exposure (曝光) settings.
//   double _minAvailableExposureOffset = 0.0;
//   double _maxAvailableExposureOffset = 0.0;
//   double _currentExposureOffset = 0.0;
//   // A flag to handle states when switching between cameras.
//   bool _changingCameraLens = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _initialize();
//   }

//   void _initialize() async {
//     if (_cameras.isEmpty) {
//       _cameras = await availableCameras();
//     }
//     for (var i = 0; i < _cameras.length; i++) {
//       if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
//         _cameraIndex = i;
//         break;
//       }
//     }
//     if (_cameraIndex != -1) {
//       _startLiveFeed();
//     }
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _stopLiveFeed();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _liveFeedBody(),
//     );
//   }

//   Widget _liveFeedBody() {
//     if (_cameras.isEmpty) return Container();
//     if (_controller == null) return Container();
//     if (_controller?.value.isInitialized == false) return Container();
//     return ColoredBox(
//       color: Colors.black,
//       child: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           Center(
//             child: _changingCameraLens
//                 ? Center(
//                     child: const Text('Changing camera lens'),
//                   )
//                 : CameraPreview(
//                     _controller!,
//                     child: widget.customPaint,
//                   ),
//           ),
//           _backButton(),
//           _switchLiveCameraToggle(),
//           _detectionViewModeToggle(),
//           _zoomControl(),
//         ],
//       ),
//     );
//   }

//   // for return back to last page
//   Widget _backButton() => Positioned(
//         top: 40,
//         left: 8,
//         child: SizedBox(
//           height: 50.0,
//           width: 50.0,
//           child: FloatingActionButton(
//             heroTag: Object(),
//             onPressed: () => Navigator.of(context).pop(),
//             backgroundColor: Colors.black54,
//             child: Icon(
//               Icons.arrow_back_ios_outlined,
//               size: 20,
//             ),
//           ),
//         ),
//       );

//   // change the detection view from liveFeed to gallery o viceversa
//   Widget _detectionViewModeToggle() => Positioned(
//         bottom: 8,
//         left: 8,
//         child: SizedBox(
//           height: 50.0,
//           width: 50.0,
//           child: FloatingActionButton(
//             heroTag: Object(),
//             onPressed: widget.onDetectorViewModeChanged,
//             backgroundColor: Colors.black54,
//             child: Icon(
//               Icons.touch_app_outlined,
//               size: 25,
//             ),
//           ),
//         ),
//       );

//   Widget _zoomControl() => Positioned(
//         bottom: 16,
//         left: 0,
//         right: 0,
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: SizedBox(
//             width: 250,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: Slider(
//                     value: _currentZoomLevel,
//                     min: _minAvailableZoom,
//                     max: _maxAvailableZoom,
//                     activeColor: Colors.white,
//                     inactiveColor: Colors.white30,
//                     onChanged: (value) async {
//                       setState(() {
//                         _currentZoomLevel = value;
//                       });
//                       await _controller?.setZoomLevel(value);
//                     },
//                   ),
//                 ),
//                 Container(
//                   width: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Center(
//                       child: Text(
//                         '${_currentZoomLevel.toStringAsFixed(1)}x',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );

//   // switch of Caemra: Front --> Back or Back --> Front
//   Widget _switchLiveCameraToggle() => Positioned(
//         bottom: 8,
//         right: 8,
//         child: SizedBox(
//           height: 50.0,
//           width: 50.0,
//           child: FloatingActionButton(
//             heroTag: Object(),
//             onPressed: _switchLiveCamera,
//             backgroundColor: Colors.black54,
//             child: Icon(
//               Platform.isIOS
//                   ? Icons.flip_camera_ios_outlined
//                   : Icons.flip_camera_android_outlined,
//               size: 25,
//             ),
//           ),
//         ),
//       );

//   Future _startLiveFeed() async {
//     final camera = _cameras[_cameraIndex];
//     _controller = CameraController(camera, ResolutionPreset.high,
//         enableAudio: false,
//         imageFormatGroup: Platform.isAndroid
//             ? ImageFormatGroup.nv21
//             : ImageFormatGroup.bgra8888);
//     _controller?.initialize().then((_) {
//       // Once initialization is complete, it checks if the widget is still mounted.
//       // If not, it returns immediately to prevent any state updates on a disposed widget.
//       // When a State object is mounted, it means that it is currently attached to the widget tree
//       // and is actively participating in the widget's lifecycle, including building and rendering.
//       if (!mounted) {
//         // This property is often used to check if it's safe to perform certain operations,
//         // such as setting state or scheduling tasks, especially in scenarios where
//         // asynchronous operations may complete after the widget has been removed from the tree.
//         return;
//       }
//       _controller?.getMinZoomLevel().then((value) {
//         _currentZoomLevel = value;
//         _minAvailableZoom = value;
//       });
//       _controller?.getMaxZoomLevel().then((value) {
//         _maxAvailableZoom = value;
//       });
//       _currentExposureOffset = 0.0;
//       _controller?.getMinExposureOffset().then((value) {
//         _minAvailableExposureOffset = value;
//       });
//       _controller?.getMaxExposureOffset().then((value) {
//         _maxAvailableExposureOffset = value;
//       });
//       //
//       _controller?.startImageStream(_processCameraImage).then((value) {
//         // Calls onCameraFeedReady callback if it's not null,
//         // indicating that the camera feed is ready.
//         if (widget.onCameraFeedReady != null) {
//           widget.onCameraFeedReady!();
//         }
//         if (widget.onCameraLensDirectionChanged != null) {
//           // Calls onCameraLensDirectionChanged with the current camera's lens direction
//           widget.onCameraLensDirectionChanged!(camera.lensDirection);
//         }
//       });
//       setState(() {});
//     });
//   }

//   Future _stopLiveFeed() async {
//     await _controller?.stopImageStream();
//     await _controller?.dispose();
//     _controller = null;
//   }

//   Future _switchLiveCamera() async {
//     setState(() => _changingCameraLens = true);
//     _cameraIndex = (_cameraIndex + 1) % _cameras.length;

//     await _stopLiveFeed();
//     await _startLiveFeed();
//     setState(() => _changingCameraLens = false);
//   }

//   void _processCameraImage(CameraImage image) {
//     final inputImage = _inputImageFromCameraImage(image);
//     if (inputImage == null) return;
//     widget.onImage(inputImage);
//   }

//   void takeImage(CameraImage image) {
//     final inputImage = _inputImageFromCameraImage(image);
//     if (inputImage == null) return;
//     List<Face> faces = widget.onImage(inputImage);
//     if (faces.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//         "There is No Face to be registered",
//         style: TextStyle(fontSize: 20),
//       )));
//     }
//     if (faces.length > 1) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//         "You can only registered one face at time",
//         style: TextStyle(fontSize: 20),
//       )));
//     }
//     if (faces.length == 1) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//         "Registering User",
//         style: TextStyle(fontSize: 20),
//       )));
//     }
//   }

//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };

//   // Preprocessing for CameraImage to turn it into InputImage then be feeded to Google_ml_kit model
//   InputImage? _inputImageFromCameraImage(CameraImage image) {
//     if (_controller == null) return null;
//     // get image rotation
//     // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
//     // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
//     // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart

//     final camera = _cameras[_cameraIndex];
//     // Retrieves the camera's sensor orientation, which indicates the
//     // physical orientation of the sensor when pictures are taken.
//     final sensorOrientation = camera.sensorOrientation;
//     print(
//         'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       // for IOS use directly the sensor orientation as the rotation
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       // For android, calculates 'rotationCompensation' based on the current device oreintation
//       // and adjusts it based on whether the camera is front or back-facing.
//       var rotationCompensation =
//           _orientations[_controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//       if (camera.lensDirection == CameraLensDirection.front) {
//         // front-facing
//         // using modulo 360 ensures the rotation value is within the 0-359 degress range
//         rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
//       } else {
//         // back-facing
//         rotationCompensation =
//             (sensorOrientation - rotationCompensation + 360) % 360;
//       }
//       rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
//       // print('rotationCompensation: $rotationCompensation');
//     }
//     if (rotation == null) return null;

//     // get image format
//     final format = InputImageFormatValue.fromRawValue(image.format.raw);
//     // validate format depending on platform
//     // only supported formats:
//     // * nv21 for Android
//     // * bgra8888 for iOS
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

//     // since format is constraint to nv21 or bgra8888, both only have one plane
//     if (image.planes.length != 1) return null;
//     final plane = image.planes.first;

//     // compose InputImage using bytes
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(image.width.toDouble(), image.height.toDouble()),
//         rotation: rotation, // used only in Android
//         format: format, // used only in iOS
//         bytesPerRow: plane.bytesPerRow, // used only in iOS
//       ),
//     );
//   }
// }
