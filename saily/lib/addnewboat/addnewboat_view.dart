import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:saily/settings/settings_controller.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  TakePictureScreen({
    super.key,
    required this.settingsController,
    required this.onQRCodeTaken
  }){
    camera = settingsController.getCamera();
  }

  SettingsController settingsController;
  late CameraDescription camera; 
  void Function(String scannedId) onQRCodeTaken;

  @override
  TakePictureScreenState createState() => TakePictureScreenState(onQRCodeTaken: onQRCodeTaken);
}

class TakePictureScreenState extends State<TakePictureScreen> {
  TakePictureScreenState({required this.onQRCodeTaken});
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  void Function(String) onQRCodeTaken;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium,);

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // where it was saved.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            Navigator.pop(context);

            onQRCodeTaken("0XAABBCCDD");
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      )
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}