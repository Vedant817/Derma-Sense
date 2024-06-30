import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:derma_sense/image__provider.dart';

class ResponsePage extends StatelessWidget {
  const ResponsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageFile = context.watch<ImageProviderCustom>().imageFile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis Page'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(imageFile!.path),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Material(
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(219, 233, 254, 1),
                  borderRadius: BorderRadius.circular(-20),
                ),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, false);
                          },
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(96, 160, 255, 1),
                            ),
                            child: const Icon(
                              Icons.home,
                              size: 50,
                              color: Color.fromRGBO(219, 233, 245, 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Our Analysis Indicates signs of',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(96, 160, 255, 1),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          height: 40,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(96, 160, 255, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Diagnosis',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromRGBO(96, 160, 255, 1),
                                width: 3.0),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Please remember, this is only a preliminary assessment and not a definitive diagnosis.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(96, 160, 255, 1),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  'Next Steps for Your Health:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(96, 160, 255, 1),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'We Strongly recommend that you consult with a healthcare professional to get a thorough and accurate diagnosis',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(96, 160, 255, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
