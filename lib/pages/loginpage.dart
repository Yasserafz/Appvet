import 'package:appvet/styles/HomePageStyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appvet/widgets/toast.dart';

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
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
        title: Text("VETAPP"),
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
      // Authentification avec Firebase
      var credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);

      showToast(message: "User is successfully signed in");
      Navigator.pushReplacementNamed(
          context, "/home"); // Utilisation de pushReplacementNamed
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        showToast(message: "No user found for that email.");
      } else if (e.code == "wrong-password") {
        showToast(message: "Wrong password provided.");
      } else {
        showToast(message: "${e.code}.");
      }
    } finally {
      setState(() {
        _isSigning = false;
      });
    }
  }
}
