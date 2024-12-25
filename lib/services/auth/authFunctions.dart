import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterlingo/models/userModel.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController nameController = TextEditingController();

Future<void> registerUser({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  // Show the CircularProgressIndicator
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissal during processing
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    // Create user with email and password
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Dismiss the CircularProgressIndicator after user creation
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }

    // Get the newly created user's ID
    String uid = userCredential.user?.uid ?? '';

    // Create a UserModel instance
    UserModel newUser = UserModel(
      email: email,
      isAdmin: false, // Default to non-admin
    );

    // Save the user data to Firestore
    await FirebaseFirestore.instance
        .collection('users') // Your collection name
        .doc(uid) // Document ID as the user's UID
        .set(newUser.toJson());

    print("User registered and data saved successfully.");

    // Optionally, navigate to another page
  } catch (e) {
    print("Failed to register user: $e");

    // Dismiss the CircularProgressIndicator in case of error
    Navigator.of(context).pop();

    // Show an error message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to register user: $e")),
    );
  }
}

Future<void> loginUser({email, password}) async {
  try {
    // Create user with email and password
    UserCredential? userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    print("User registered and data saved successfully.");
  } catch (e) {
    print("Failed to register user: $e");
  }
}
