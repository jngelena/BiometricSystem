import 'package:app/screen/face_detector.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Registration"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Center(
      child: SizedBox(
        width: 350,
        height: 80,
        child: OutlinedButton(
          onPressed: () async {
            final cameras = await availableCameras();
            print(cameras);
            final firstCamera = cameras[1];
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FaceDetectorView()));
          },
          style: ButtonStyle(
              side: MaterialStateProperty.all(const BorderSide(
                  color: Colors.blue, width: 1.0, style: BorderStyle.solid))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconWidget(Icons.arrow_forward),
              Text("Face Registration", style: TextStyle(fontSize: 20)),
              _buildIconWidget(Icons.arrow_back),
            ],
          ),
        ),
      ),
    );
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
