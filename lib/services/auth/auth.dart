import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlingo/pages/home_page.dart';
import 'package:flutterlingo/services/auth/login_or_reg.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isLoggedIn = false; // Flag to track the login state

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        isLoggedIn = user != null; // Update the flag based on login state
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoggedIn
          ? const HomePage() // Navigate to HomePage if logged in
          : const LoginOrReg(), // Show login or registration if not logged in
    );
  }
}
