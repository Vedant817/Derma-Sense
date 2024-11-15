import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'no_camera_screen.dart';
import 'login_screen.dart';
import 'package:derma_sense/image__provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final cameras = await availableCameras();

  if (cameras.isEmpty) {
    runApp(const NoCameraApp());
    return;
  }

  final firstCamera = cameras.first;
  final isLoggedIn = await checkLoginStatus();

  runApp(App(camera: firstCamera, isLoggedIn: isLoggedIn));
}

Future<bool> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final lastLogin = prefs.getInt('lastLoginTime');

  if (lastLogin == null) {
    return false;
  }

  final now = DateTime.now().millisecondsSinceEpoch;
  final difference = now - lastLogin;
  const twoDaysInMilliseconds = 2 * 24 * 60 * 60 * 1000;

  return difference <= twoDaysInMilliseconds;
}

class App extends StatelessWidget {
  final CameraDescription camera;
  final bool isLoggedIn;

  const App({super.key, required this.camera, required this.isLoggedIn});

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
        home:
            isLoggedIn ? HomePage(camera: camera) : LoginScreen(camera: camera),
      ),
    );
  }
}
