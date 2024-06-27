import 'package:derma_sense/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(App(camera: firstCamera));
}

class App extends StatelessWidget {
  final CameraDescription camera;
  const App({super.key, required this.camera});

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
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(219, 233, 245, 1),
        useMaterial3: true,
      ),
      home: HomePage(camera: camera),
    );
  }
}
