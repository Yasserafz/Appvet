import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    // Vérifie si un utilisateur est connecté ou non
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Redirige vers la page de connexion si l'utilisateur n'est pas connecté
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // Redirige vers la page d'accueil si l'utilisateur est connecté
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Welcome To Flutter Firebase",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
