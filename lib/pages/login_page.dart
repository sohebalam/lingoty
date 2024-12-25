import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlingo/components/helper_func.dart';
import 'package:flutterlingo/components/my_button.dart';
import 'package:flutterlingo/components/my_textfield.dart';
import 'package:flutterlingo/services/auth/authFunctions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.onTap}) : super(key: key);
  final void Function()? onTap;

  @override
  _LoginPageState createState() => _LoginPageState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> login() async {
    setLoading(true);

    try {
      await loginUser(
          email: emailController.text, password: passwordController.text);
      setLoading(false);

      // Navigate to the home page or next screen
      // Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      displayMessageToUser(e.code, context);
    } catch (e) {
      setLoading(false);
      displayMessageToUser('An unexpected error occurred${e}', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Center(
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
                        'L O G I N',
                        style: const TextStyle(fontSize: 20),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Forgot Password?"),
                        ],
                      ),
                      const SizedBox(height: 25),
                      MyButton(text: 'Login', onTap: login),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              " Register here?",
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
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
