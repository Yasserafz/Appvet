import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page d\'accueil'),
      ),
      body: Center(
        child: Text(
          'Bienvenue dans votre application !',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
