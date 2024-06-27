// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final CameraDescription camera;

  const HomePage({super.key, required this.camera});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? _imageFile;
  bool _isFlashOn = false;
  bool _isPhotoClicked = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, '${DateTime.now()}.png'); /// WIll use later

      final image = await _controller.takePicture();
      setState(() {
        _imageFile = image;
        _isPhotoClicked = true;
      });
    } catch (e) {
      // print(e);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
      _isPhotoClicked = true;
    });
  }

  Future<void> _toggleFlash() async {
    if (_controller.value.isInitialized) {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
      await _controller.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('YOUR_API_ENDPOINT_HERE'),
      );
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _imageFile!.path,
      ));
      var response = await request.send();

      if (response.statusCode == 200) {
        // print('Image uploaded successfully');
      } else {
        // print('Image upload failed');
      }
    } catch (e) {
      // print('Error uploading image: $e');
    }
  }

  Future<bool> _onWillPop() async {
    if (_isPhotoClicked) {
      setState(() {
        _imageFile = null;
        _isPhotoClicked = false;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (_imageFile != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(_imageFile!.path),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CameraPreview(_controller),
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  if (!_isPhotoClicked)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      // width: double.infinity, /// Avoid using
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              onPressed: _takePicture,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                side: const BorderSide(color: Color.fromRGBO(96, 160, 255, 1), width: 3.0)
                              ),
                              child: const Icon(Icons.camera_alt),
                            ),
                            const SizedBox(width: 16),
                            FloatingActionButton(
                              onPressed: _toggleFlash,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: const BorderSide(color: Color.fromRGBO(96, 160, 255, 1), width: 3.0)
                              ),
                              child: Icon(
                                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImageFromGallery,
                      icon: const Icon(Icons.photo_library, color: Color.fromRGBO(219, 233, 254, 1),),
                      label: Text('Image', style: Theme.of(context).textTheme.bodyLarge,),
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: Theme.of(context).colorScheme.primary,
                          backgroundColor: const Color.fromRGBO(96, 160, 255, 1)
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isPhotoClicked ? _uploadImage : null,
                      icon: const Icon(Icons.upload_file, color: Color.fromRGBO(219, 233, 254, 1),),
                      label: Text('Upload', style: Theme.of(context).textTheme.bodyLarge,),
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: const Color.fromRGBO(96, 160, 255, 1)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Brewed by Keshav and Akshit\nA special thanks to Vedant Mahajan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(96, 160, 255, 1),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
