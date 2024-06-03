import 'package:app/components/components.dart';
import 'package:app/screen/sign_up.dart';
import 'package:camera/camera.dart';
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
  bool _startWithInfo = true;
  bool _allowAfterTimeOut = false;
  int _timeOutDuration = 15;
  final List<M7LivelynessStepItem> _verificationSteps = [];

  @override
  void initState() {
    _initValues();
    super.initState();
  }

  void _initValues() {
    _verificationSteps.addAll([
      M7LivelynessStepItem(
          step: M7LivelynessStep.smile, title: "Smile", isCompleted: false),
      M7LivelynessStepItem(
          step: M7LivelynessStep.blink, title: "Blink", isCompleted: false),
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
                  onPressed: () {},
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
