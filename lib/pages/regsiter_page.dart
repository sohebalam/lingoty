import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlingo/pages/home_page.dart';
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
  bool isLoading = false;

  Future<void> register() async {
    if (passwordController.text != confirmPasswordController.text) {
      displayMessageToUser("Passwords don't match", context);
      return; // Exit early if passwords don't match
    }

    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    // Show the loading dialog
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      print("Attempting to register user with email: ${emailController.text}");

      // Try to register the user
      await registerUser(
        email: emailController.text,
        password: passwordController.text,
        context: context,
      );

      if (mounted) {
        print("User registered and data saved successfully");

        // Close the dialog and dismiss loading
        Navigator.pop(context); // Close the loading dialog
        setState(() {
          isLoading = false;
        });

        // Short delay for smooth transition
        await Future.delayed(const Duration(milliseconds: 200));

        // Dismiss keyboard before navigating
        FocusScope.of(context).unfocus();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        // Close the loading dialog before showing the error
        Navigator.pop(context); // Close the dialog

        // Dismiss loading and show appropriate message
        setState(() {
          isLoading = false;
        });

        if (e.code == 'email-already-in-use') {
          displayMessageToUser(
              'This email is already registered. Please log in.', context);
        } else {
          displayMessageToUser(e.message ?? "An error occurred", context);
        }
        print("FirebaseAuthException: ${e.code}");
      }
    } catch (e) {
      if (mounted) {
        // Handle any other unexpected errors
        Navigator.pop(context); // Close the dialog before showing the error
        setState(() {
          isLoading = false;
        });
        displayMessageToUser('An unexpected error occurred', context);
        print("Unexpected error: $e");
      }
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
                  const SizedBox(height: 25),
                  Text(
                    'R E G I S T E R',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 50),
                  MyTextfield(
                    hintText: "Email",
                    obscureText: false,
                    controller: emailController,
                  ),
                  const SizedBox(height: 10),
                  MyTextfield(
                    hintText: "Password",
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 10),
                  MyTextfield(
                    hintText: "Confirm Password",
                    obscureText: true,
                    controller: confirmPasswordController,
                  ),
                  const SizedBox(height: 25),
                  MyButton(text: 'Register', onTap: register),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          " Login here?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
