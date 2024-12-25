import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlingo/services/auth/authFunctions.dart';
import 'package:flutterlingo/components/helper_func.dart';
import 'package:flutterlingo/components/my_button.dart';
import 'package:flutterlingo/components/my_textfield.dart';
import 'package:flutterlingo/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

class _RegisterPageState extends State<RegisterPage> {
  Future<void> register() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context); // Close the loading dialog
      displayMessageToUser(
          "Passwords don't match", context); // Show the message
      return; // Exit the function to prevent further execution
    }

    try {
      await registerUser(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: true, // Adjust screen when keyboard is shown
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            // Allows the screen to scroll when keyboard is shown
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 80,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'R E G I S T E R',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MyTextfield(
                      hintText: "Email",
                      obscureText: false,
                      controller: emailController),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextfield(
                      hintText: "Password",
                      obscureText: true,
                      controller: passwordController),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextfield(
                      hintText: "Confirm Password",
                      obscureText: true,
                      controller: confirmPasswordController),
                  const SizedBox(
                    height: 25,
                  ),
                  MyButton(text: 'register', onTap: register),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text(
                      "Don't have an account?",
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        " Login here?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}