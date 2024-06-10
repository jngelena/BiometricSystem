import 'dart:developer';
import 'package:app/components/components.dart';
import 'package:app/model/user.dart';
import 'package:app/screen/log_in.dart';
import 'package:app/screen/sign_up.dart';
import 'package:app/service/Firebase_database.dart';
import 'package:app/service/deep_face_api.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:m7_livelyness_detection/index.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _capturedImagePath;
  final bool _isLoading = false;
  final bool _clickedFromRegistrationButton = false;
  final bool _clickedfromLoginButton = false;
  FirebaseMethods? firebaseInstance;
  DeepFaceApi? deepFaceApi;

  bool _startWithInfo = true;
  bool _allowAfterTimeOut = false;
  int _timeOutDuration = 15;
  final List<M7LivelynessStepItem> _verificationSteps = [];

  @override
  void initState() {
    _initValues();
    firebaseInstance = FirebaseMethods();
    deepFaceApi = DeepFaceApi();
    super.initState();
  }

  void _initValues() {
    _verificationSteps.addAll([
      M7LivelynessStepItem(
          step: M7LivelynessStep.blink, title: "Blink", isCompleted: false),
      M7LivelynessStepItem(
          step: M7LivelynessStep.smile, title: "Smile", isCompleted: false),
    ]);
    M7LivelynessDetection.instance.configure(
      thresholds: [
        M7SmileDetectionThreshold(probability: 0.8),
        M7BlinkDetectionThreshold(
            leftEyeProbability: 0.25, rightEyeProbability: 0.25)
      ],
    );
  }

  Future<void> _onStartLivelyness() async {
    setState(() {
      _capturedImagePath = null;
    });
    final M7CapturedImage? response =
        await M7LivelynessDetection.instance.detectLivelyness(
      context,
      config: M7DetectionConfig(
          steps: _verificationSteps,
          startWithInfoScreen: _startWithInfo,
          maxSecToDetect: _timeOutDuration == 100 ? 2500 : _timeOutDuration,
          allowAfterMaxSec: _allowAfterTimeOut,
          captureButtonColor: Colors.red),
    );
    if (response == null) {
      return;
    }
    setState(() {
      _capturedImagePath = response.imgPath!;
      print("The image path that has been captured: ${_capturedImagePath}");
    });
  }

  void _write(String text) async {
    final directory = Directory.current.path;
    final File file = File('${directory}my_file.txt');
    print('${directory}my_file.txt');
    await file.writeAsString(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TopScreenImage(screenImageName: 'blockchainIllustration.png'),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(right: 15.0, left: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const ScreenTitle(title: "Hello"),
                const Text(
                  'Welcome to B-Voting, Where you can vote things via Blockchain',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                  buttonText: "Login",
                  onPressed: () async {
                    List<User> documents =
                        await firebaseInstance!.getUsersFromFirestore();
                    await _onStartLivelyness();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.black,
                        content: Text(
                          "Processing the data for Log In",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )));
                    if (_capturedImagePath != null) {
                      final file = File(_capturedImagePath!);
                      Uint8List filebytes = file.readAsBytesSync();
                      String base64FileBytes = base64Encode(filebytes);
                      for (var i = 0; i < documents.length; i++) {
                        bool reply = await deepFaceApi!
                            .verifyFace(base64FileBytes, documents[i].image);
                        if (reply == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => VotingPage(
                                        user: documents[i],
                                      ))));
                        } else if (i + 1 == documents.length &&
                            reply == false) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.black,
                                  content: Text(
                                    "You are not Registered!",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  )));
                        }
                      }
                    }
                    print(
                        "There is document from firestore: ${documents[0].image}");
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  buttonText: "Sign Up",
                  onPressed: () async {
                    await _onStartLivelyness();
                    if (_capturedImagePath != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext _build) {
                        return SignUpPage(imagePath: _capturedImagePath!);
                      }));
                    }
                  },
                  isOutlined: true,
                ),
              ],
            ),
          ))
        ],
      ),
    ));
  }

  Widget _buildIconWidget(IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Icon(
        icon,
        size: 24,
      ),
    );
  }
}
