import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlingo/model/auth_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  AuthModel _user = AuthModel(id: "", name: "", email: "");
  bool _isLoading = false;
  AuthModel get user => _user;
  bool get isLoading => _isLoading;

  Future<void> signUp(String name, String password, String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      AuthModel authModel = AuthModel(
          id: firebaseAuth.currentUser!.uid, name: name, email: email);
      await firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .set(authModel.toMap());
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        throw Exception("invalid email");
      } else if (e.code == "weak-password") {
        throw "The password provided is too weak.";
      }
      print(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AuthModel> getUserData() async {
    var user = await firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    var userData = user.data();
    if (userData != null) {
      _user = AuthModel.fromMap(userData);
      notifyListeners();
    }

    return _user;
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        throw Exception("incorect email");
      } else if (e.code == "wrong-password") {
        throw "incorrect password.";
      }
      print(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setLoading(bool bool) {}
}
