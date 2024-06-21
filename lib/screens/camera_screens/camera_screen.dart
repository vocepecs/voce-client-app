// A screen that allows users to take a picture using a given camera.

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:voce/main.dart';
import 'package:voce/models/constants/constant_graphics.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    Key? key,
    // required this.camera,
  }) : super(key: key);

  // final CameraDescription camera;

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scatta una foto'),
      ),
      body: CameraPreview(_controller),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ConstantGraphics.colorPink,
        onPressed: () async {
          try {
            final image = await _controller.takePicture();
            Navigator.of(context).pop(image);
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(
          Icons.camera_alt,
          size: 30,
        ),
      ),
    );
  }
}
