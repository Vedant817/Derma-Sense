import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:derma_sense/image__provider.dart';
import 'package:http/http.dart' as http;

class ResponsePage extends StatelessWidget {
  const ResponsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageFile = context.watch<ImageProviderCustom>().imageFile;
    final diagnosisProvider = context.watch<DiagnosisProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis Page'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: diagnosisProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : diagnosisProvider.diagnosis != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                    height: 300,
                    width: double.infinity,
                    // fit: BoxFit.cover,
                    child: Image.file(File(imageFile!.path)))),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFD6E4FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.home,
                    size: 50,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Our Analysis Indicates signs of',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    diagnosisProvider.diagnosis!.diagnosis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please remember, this is only a preliminary assessment and not a definitive diagnosis.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Next Steps for Your Health:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          diagnosisProvider.diagnosis!.nextSteps,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          : const Center(child: Text('No diagnosis available')),
    );
  }
}

class Diagnosis {
  final String diagnosis;
  final String nextSteps;

  Diagnosis({required this.diagnosis, required this.nextSteps});

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      diagnosis: json['diagnosis'],
      nextSteps: json['next_steps'],
    );
  }
}

class ApiService {
  static const String apiUrl = 'YOUR_API_ENDPOINT_HERE';

  Future<Diagnosis> fetchDiagnosis() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return Diagnosis.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load diagnosis');
    }
  }
}

class DiagnosisProvider with ChangeNotifier {
  Diagnosis? _diagnosis;
  bool _isLoading = false;

  Diagnosis? get diagnosis => _diagnosis;
  bool get isLoading => _isLoading;

  Future<void> fetchDiagnosis() async {
    _isLoading = true;
    notifyListeners();

    _diagnosis = await ApiService().fetchDiagnosis();

    _isLoading = false;
    notifyListeners();
  }
}
