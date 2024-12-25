import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterlingo/models/userModel.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController nameController = TextEditingController();

Future<void> registerUser({email, password}) async {
  try {
    // Create user with email and password
    UserCredential? userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

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
  } catch (e) {
    print("Failed to register user: $e");
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
