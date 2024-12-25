import 'package:flutter/material.dart';
import 'package:flutterlingo/pages/login_page.dart';
import 'package:flutterlingo/pages/regsiter_page.dart';

class LoginOrReg extends StatefulWidget {
  const LoginOrReg({Key? key}) : super(key: key);

  @override
  _LoginOrRegState createState() => _LoginOrRegState();
}

class _LoginOrRegState extends State<LoginOrReg> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
