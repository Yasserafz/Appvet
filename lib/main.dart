import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appvet/features/app/splash_screen/splash_screen.dart';
import 'package:appvet/features/user_auth/presentation/pages/home_page.dart';
import 'package:appvet/features/user_auth/presentation/pages/login_page.dart';
import 'package:appvet/features/user_auth/presentation/pages/sign_up_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyDI__qxgwTHn_YVaIotflLoul7tDyOk9Po",
            appId: "1:869539575129:web:e8eccb1fb3d44b514e4848",
            messagingSenderId: "869539575129",
            projectId: "flutter-firebase-9028a",
          )
        : null, // Automatically initialize for mobile
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
