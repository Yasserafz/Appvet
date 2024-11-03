/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestFirebaseScreen extends StatelessWidget {
  // Fonction pour tester la connexion anonyme
  Future<void> testAnonymousSignIn(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();

      // Vérifie si l'utilisateur est bien connecté et affiche l'UID
      User? user = userCredential.user;
      if (user != null) {
        print("Connexion anonyme réussie : ${user.uid}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connexion anonyme réussie : ${user.uid}")),
        );
      } else {
        print("Erreur : utilisateur anonyme non trouvé");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : utilisateur anonyme non trouvé")),
        );
      }
    } catch (e, stackTrace) {
      // Affiche l'erreur complète pour le débogage
      print("Erreur de connexion : $e");
      print("Stack trace : $stackTrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Firebase Auth"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => testAnonymousSignIn(context),
          child: Text("Tester Connexion Anonyme"),
        ),
      ),
    );
  }
}
*/
