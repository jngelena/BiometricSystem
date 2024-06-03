import 'package:app/components/components.dart';
import 'package:app/screen/home_page.dart';
import 'package:app/service/Firebase_database.dart';
import 'package:app/service/deep_face_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:m7_livelyness_detection/index.dart';

class SignUpPage extends StatefulWidget {
  final String imagePath;
  const SignUpPage({
    super.key,
    required this.imagePath,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  DeepFaceApi? deepFaceApi;
  FirebaseMethods? firebaseInstance;
  String? name, email;
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    deepFaceApi = DeepFaceApi();
    firebaseInstance = FirebaseMethods();
    super.initState();
  }

  void registration() {
    if (_formkey.currentState!.validate()) {
      setState(() {
        email = emailController.text;
        name = nameController.text;
      });
      try {
        final file = File(widget.imagePath);
        Uint8List fileBytes = file.readAsBytesSync();
        String base64FileBytes = base64Encode(fileBytes);
        Map<String, String> userInformation = {
          "Email": email!,
          "Name": name!,
          "Image": base64FileBytes,
        };
        firebaseInstance!.addUsers(userInformation);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20, color: Colors.white),
            )));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => Home())));
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "Something went wrong",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('SignUp'),
        ),
        body: _body());
  }

  Widget _body() {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        caputuredImage(),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: SignUpForm(),
            ),
            Spacer()
          ],
        ),
        // CustomButton(
        //     buttonText: "Verify Face",
        //     onPressed: () {
        //       deepFaceApi!
        //           .verifyFace("images/mobile1.jpeg", "images/Mobile2.jpeg");
        //     })
      ],
    ));
  }

  Widget caputuredImage() {
    File imageFile = File(widget.imagePath);
    FileImage fileImage = FileImage(imageFile);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: fileImage,
          ),
        ),
      ),
    );
  }

  Widget SignUpForm() {
    return Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: Colors.black,
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the Email";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Your Email",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.email_outlined),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                cursorColor: Colors.black,
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the Name";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "Your Name",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(Icons.person_outlined),
                    )),
              ),
            ),
            const SizedBox(height: 5),
            CustomButton(
                buttonText: "Sign Up",
                onPressed: () {
                  registration();
                }),
            const SizedBox(
              height: 16,
            ),
            AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Home();
                  }));
                })
          ],
        ));
  }
}
