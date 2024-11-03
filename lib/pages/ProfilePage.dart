import 'package:appvet/styles/HomePageStyle.dart';
import 'package:appvet/styles/ProfilePageStyle.dart'; // Utiliser votre fichier de style
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String email;
  late String birthday;
  late String address;
  late String postalCode;
  late String city;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();

      if (userData.exists) {
        setState(() {
          email = user.email ?? '';
          birthday = userData['birthday'] ?? '';
          address = userData['address'] ?? '';
          postalCode = userData['postalCode'] ?? '';
          city = userData['city'] ?? '';
        });
      } else {
        _createDefaultUserData(user.uid);
      }
    }
  }

  Future<void> _createDefaultUserData(String userId) async {
    await _firestore.collection('users').doc(userId).set({
      'birthday': '',
      'address': '',
      'postalCode': '',
      'city': '',
    });
    _fetchUserData();
  }

  Future<void> _saveUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'birthday': birthday,
        'address': address,
        'postalCode': postalCode,
        'city': city,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil mis à jour avec succès')),
      );
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Mon Profil"),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _saveUserData();
              }
            },
            child: const Text(
              "Valider",
              style: TextStyle(
                  color:
                      validateTextColor), // Couleur pour le texte de validation
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: email,
                readOnly: true,
                decoration: InputDecoration(labelText: "Login"),
              ),
              TextFormField(
                initialValue: '',
                obscureText: true,
                decoration: InputDecoration(labelText: "Mot de passe"),
              ),
              TextFormField(
                initialValue: birthday,
                decoration: InputDecoration(labelText: "Anniversaire"),
                onChanged: (value) {
                  birthday = value;
                },
              ),
              TextFormField(
                initialValue: address,
                decoration: InputDecoration(labelText: "Adresse"),
                onChanged: (value) {
                  address = value;
                },
              ),
              TextFormField(
                initialValue: postalCode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Code Postal"),
                onChanged: (value) {
                  postalCode = value;
                },
              ),
              TextFormField(
                initialValue: city,
                decoration: InputDecoration(labelText: "Ville"),
                onChanged: (value) {
                  city = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // Utiliser la couleur définie
                ),
                child: const Text("Déconnexion"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
