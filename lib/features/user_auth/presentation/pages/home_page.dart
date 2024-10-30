import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../global/common/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("HomePage"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<List<UserModel>>(
                stream: _readData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Data Yet"));
                  }
                  final users = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: users.map((user) {
                        return Card(
                          // Utilisation d'une carte pour un meilleur affichage
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(user.username ?? "Unknown User"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Address: ${user.adress ?? "Unknown Address"}"),
                                Text("City: ${user.city ?? "Unknown City"}"),
                                Text(
                                    "Birthday: ${user.birthday ?? "Unknown Birthday"}"),
                                Text("Email: ${user.email ?? "Unknown Email"}"),
                                Text(
                                    "Postal Code: ${user.postalCode ?? "Unknown Postal Code"}"),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/login");
                  showToast(message: "Successfully signed out");
                },
                child: Container(
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Sign out",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<List<UserModel>> _readData() {
    final userCollection = FirebaseFirestore.instance.collection("users");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }
}

class UserModel {
  final String? username;
  final String? adress;
  final String? birthday; // Ajout du champ birthday
  final String? city; // Ajout du champ city
  final String? email; // Ajout du champ email
  final String? postalCode; // Ajout du champ postalCode
  final String? id;

  UserModel({
    this.id,
    this.username,
    this.adress,
    this.birthday,
    this.city,
    this.email,
    this.postalCode,
  });

  static UserModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return UserModel(
      id: snapshot.id,
      username: data['username'] ?? "Unknown",
      adress: data['adress'] ?? "Unknown Address",
      birthday: data['birthday'] ?? "Unknown Birthday",
      city: data['city'] ?? "Unknown City",
      email: data['email'] ?? "Unknown Email",
      postalCode: data['postalCode'] ?? "Unknown Postal Code",
    );
  }
}
