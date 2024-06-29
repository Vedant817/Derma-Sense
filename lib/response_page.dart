import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ResponsePage extends StatefulWidget {
  final XFile imageFile; // Change type to XFile or File as needed

  const ResponsePage({super.key, required this.imageFile});

  @override
  _ResponsePageState createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Response Page'),
      ),
      body: Center(
        child: Image.file(
          File(widget.imageFile.path), // Convert XFile to File if needed
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
