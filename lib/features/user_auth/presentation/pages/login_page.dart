import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure you import this library
import 'package:flutter/material.dart';
import 'package:appvet/global/common/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  TextEditingController _usernameController =
      TextEditingController(); // Renamed the controller for the username
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose(); // Dispose of the username controller
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _usernameController, // Use the username controller
                decoration: InputDecoration(
                    hintText: "Username"), // Change the hint text
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: "Password"),
                obscureText: true,
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: _signIn,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigning
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/signUp");
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showToast(message: "Username and password cannot be empty.");
      setState(() {
        _isSigning = false;
      });
      return;
    }

    try {
      // Search for the user in Firestore by username
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (snapshot.docs.isEmpty) {
        showToast(message: "No user found with that username.");
        setState(() {
          _isSigning = false;
        });
        return;
      }

      // Retrieve the associated password
      String storedPassword = snapshot.docs.first['password'];

      // Check the password
      if (storedPassword != password) {
        showToast(message: "Wrong password provided.");
        setState(() {
          _isSigning = false;
        });
        return;
      }

      // If the password is correct, you can proceed with authentication
      showToast(message: "User is successfully signed in");
      Navigator.pushNamed(context, "/home");
    } catch (e) {
      showToast(message: "An error occurred: ${e.toString()}");
    } finally {
      setState(() {
        _isSigning = false;
      });
    }
  }
}
