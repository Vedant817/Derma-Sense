import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:derma_sense/response_page.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:derma_sense/image__provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      final path = join(directory.path, '${DateTime.now()}.png');

      /// WIll use later

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

  Future<bool> _onWillPop() async {
    if (_isPhotoClicked) {
      setState(() {
        _imageFile = null;
        _isPhotoClicked = false;
      });
      Provider.of<ImageProviderCustom>(context as BuildContext, listen: false)
          .removeImage();
      return false;
    } else {
      return true;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromRGBO(219, 233, 254, 1),
              title: const Text('Error', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
              content: Text(message, style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300
              ),),
              actions: [
                TextButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      // Navigator.pop(context);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 204, 204, 1)
                    ),
                    child: const Text('Close', style: TextStyle(color: Colors.red),)),
              ],
            ));
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(_imageFile!.path),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
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
                          return const Center(
                              child: CircularProgressIndicator());
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: const BorderSide(
                                      color: Color.fromRGBO(96, 160, 255, 1),
                                      width: 3.0)),
                              child: const Icon(Icons.camera_alt),
                            ),
                            const SizedBox(width: 16),
                            FloatingActionButton(
                              onPressed: _toggleFlash,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: const BorderSide(
                                      color: Color.fromRGBO(96, 160, 255, 1),
                                      width: 3.0)),
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
                      icon: const Icon(
                        Icons.photo_library,
                        color: Color.fromRGBO(219, 233, 254, 1),
                      ),
                      label: Text(
                        'Image',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      style: ElevatedButton.styleFrom(
                          // backgroundColor: Theme.of(context).colorScheme.primary,
                          backgroundColor:
                              const Color.fromRGBO(96, 160, 255, 1)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_isPhotoClicked && _imageFile != null) {
                          try {
                            final apiUrl = dotenv.env['API_URL'];
                            final uri = Uri.parse(apiUrl!);
                            final request = http.MultipartRequest('POST', uri);

                            request.headers['Content-Type'] =
                                'multipart/form-data';
                            request.files.add(await http.MultipartFile.fromPath(
                              'image', // This is the field name on the server
                              _imageFile!.path,
                              // filename: _imageFile!.path.split('/').last,
                            ));

                            final response = await request.send();
                            final responseBody =
                                await response.stream.bytesToString();

                            // Check the response status
                            if (response.statusCode == 200) {
                              final decodedResponse = json.decode(responseBody);
                              // Image upload successful, save the image locally
                              Provider.of<ImageProviderCustom>(context,
                                      listen: false)
                                  .saveImage(_imageFile!);

                              // Navigate to the ResponsePage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResponsePage(
                                    response: decodedResponse,
                                  ),
                                ),
                              );
                            } else {
                              _showErrorDialog(context, 'Connection Error.\nTry Again Later');
                            }
                          } catch (e) {
                            // Handle any exceptions during the upload process
                            _showErrorDialog(context, e.toString());
                          }
                        } else {
                          // Show a message if no image is provided
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Center(
                                child: SizedBox(
                                  height: 30.0,
                                  child: Text(
                                    'Please provide the image.',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Color.fromRGBO(219, 233, 254, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.upload_file,
                        color: Color.fromRGBO(219, 233, 254, 1),
                      ),
                      label: Text(
                        'Upload',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      style: ElevatedButton.styleFrom(
                          // backgroundColor: Theme.of(context).colorScheme.primary,
                          backgroundColor:
                              const Color.fromRGBO(96, 160, 255, 1)),
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
