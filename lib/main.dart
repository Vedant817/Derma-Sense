import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'home_page.dart';
import 'no_camera_screen.dart';
import 'package:provider/provider.dart';
import 'package:derma_sense/image__provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of available cameras
  final cameras = await availableCameras();

  // Ensure at least one camera is available
  if (cameras.isEmpty) {
    // Handle the case where no cameras are available
    runApp(const NoCameraApp());
    return;
  }

  // Select the first camera available
  final firstCamera = cameras.first;

  // Run the app and pass the selected camera to the HomePage
  runApp(App(camera: firstCamera));
}

class App extends StatelessWidget {
  final CameraDescription camera;

  const App({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ImageProviderCustom(),
      child: MaterialApp(
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
        home: HomePage(camera: camera),
      ),
    );
  }
}
