import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoCameraApp extends StatelessWidget {
  const NoCameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Derma Sense',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color.fromRGBO(219, 233, 254, 1),
          onPrimary: Color.fromRGBO(96, 160, 255, 1),
          surface: Color.fromRGBO(219, 233, 245, 1),
        ),
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.robotoMono(
            textStyle: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(96, 160, 255, 1),
            ),
          ),
          bodyLarge: GoogleFonts.robotoMono(
            textStyle: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(219, 233, 254, 1),
            ),
          ),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(219, 233, 245, 1),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('No Camera Available'),
        ),
        body: Center(
          child: Text(
            'No cameras are available on this device.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}