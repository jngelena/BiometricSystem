import 'package:app/components/components.dart';
import 'package:app/service/deep_face_api.dart';
import 'package:flutter/material.dart';
import 'package:m7_livelyness_detection/index.dart';

class SignUpPage extends StatefulWidget {
  //final String imagePath;
  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  DeepFaceApi? deepFaceApi;

  @override
  void initState() {
    // TODO: implement initState
    deepFaceApi = DeepFaceApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SignUp Page'),
        ),
        body: _body());
  }

  Widget _body() {
    return SafeArea(
        child: Column(
      children: [
        // Container(
        //   // if imagePath is null, an empty string will be used
        //   child: Image.file(
        //     File(""),
        //     fit: BoxFit.contain,
        //   ),
        // ),
        CustomButton(
            buttonText: "Verify Face",
            onPressed: () {
              deepFaceApi!
                  .verifyFace("images/mobile1.jpeg", "images/Mobile2.jpeg");
            })
      ],
    ));
  }
}
