import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:derma_sense/image__provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ResponsePage extends StatelessWidget {
  final String
      response; // Assuming response is a String representing the diagnosis
  const ResponsePage({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final imageFile = context.watch<ImageProviderCustom>().imageFile;

    final Map<String, String> diseaseRecommendations = {
      'Actinic keratoses':
          'Seek evaluation from a dermatologist as actinic keratoses can be precursors to skin cancer. Treatment options may include cryotherapy, topical medications, or photodynamic therapy.',
      'Basal cell carcinoma':
          'Consult with a dermatologist promptly. Basal cell carcinoma is a common type of skin cancer that rarely spreads but needs treatment. Options include surgical excision, Mohs surgery, or topical treatments.',
      'Benign keratosis-like lesions':
          'These lesions are usually non-cancerous. However, it\'s advisable to have them checked by a dermatologist to rule out any possibility of skin cancer. Treatments may include cryotherapy or laser removal if needed.',
      'Dermatofibroma':
          'Dermatofibromas are generally harmless. If it causes discomfort or cosmetic concerns, consult with a dermatologist about possible removal options.',
      'Melanoma':
          'Melanoma is a serious form of skin cancer. Immediate consultation with a dermatologist is critical for early detection and treatment, which may include surgical removal, immunotherapy, or targeted therapy.',
      'Melanocytic nevi':
          'These are common moles, usually benign. Regular self-examination and annual dermatological check-ups are advised to monitor any changes in size, shape, or color.',
      'Vascular lesions':
          'Vascular lesions are usually benign. Consult a dermatologist if you notice any changes or if the lesion causes symptoms. Treatments can include laser therapy or sclerotherapy.',
    };

    final String recommendation = diseaseRecommendations[response] ??
        'Please consult a certified dermatologist for a thorough evaluation and personalized advice.';

    return WillPopScope(
      onWillPop: () async {
        // Navigate back to home page and reload everything
        Navigator.pushReplacementNamed(context, '/');
        return true;
      },
      child: Scaffold(
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(96, 160, 255, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              response,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              minFontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Container(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromRGBO(96, 160, 255, 1),
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Next Steps for Your Health:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(96, 160, 255, 1),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    recommendation,
                                    style: const TextStyle(
                                      fontSize: 13,
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
      ),
    );
  }
}
