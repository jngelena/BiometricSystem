import 'package:flutter/material.dart';
import 'package:m7_livelyness_detection/index.dart';

class SignUpPage extends StatefulWidget {
  final String imagePath;
  const SignUpPage({super.key, required this.imagePath});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp Page'),
      ),
      body: Container(
        // if imagePath is null, an empty string will be used
        child: Image.file(
          File(widget.imagePath ?? ""),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
