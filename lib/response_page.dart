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
                          child: const Icon(
                            Icons.home,
                            size: 50,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Our Analysis Indicates signs of',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Diagnosis',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Please remember, this is only a preliminary assessment and not a definitive diagnosis.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Next Steps for Your Health:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'NextSteps',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
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
