import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterlingo/auth/signup_screen.dart';
import 'package:flutterlingo/auth/widgets/custom_button.dart';
import 'package:flutterlingo/auth/widgets/custom_checkbox.dart';
import 'package:flutterlingo/auth/widgets/custom_textfield.dart';
import 'package:flutterlingo/home_screen.dart';
import 'package:flutterlingo/provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void signUpNavigator() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const SignupScreen()));
  bool isPassword = false;
  bool isCheckBox = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    if (isCheckBox == true) {
      final signProvider = Provider.of<UserProvider>(context, listen: false);
      await signProvider.login(emailController.text, passwordController.text);
      homeNavigator();
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("Selected the check box")));
    }
  }

  void homeNavigator() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context, listen: true);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: authProvider.isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: Image.asset("assets/login.png"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextfield(
                          hintText: "Email",
                          textEditingController: emailController,
                          prefixIcon: Icons.email_outlined),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextfield(
                          onPressed: () {
                            setState(() {
                              isPassword = !isPassword;
                            });
                          },
                          obscureText: isPassword,
                          hintText: "password",
                          suffixIcon: isPassword
                              ? Icons.visibility_off_outlined
                              : Icons.remove_red_eye_outlined,
                          textEditingController: passwordController,
                          prefixIcon: Icons.password),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomCheckbox(
                            value: isCheckBox,
                            onChanged: (val) {
                              setState(() {
                                isCheckBox = !isCheckBox;
                              });
                            },
                          ),
                          const Text(
                            "Forgot password?",
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        width: double.infinity,
                        buttonText: "LOGIN",
                        onPressed: login,
                      ),
                      SizedBox(
                        height: size.height * 0.15,
                      ),
                      GestureDetector(
                        onTap: signUpNavigator,
                        child: RichText(
                          text: const TextSpan(
                              text: "Don't have an account? ",
                              children: [
                                TextSpan(
                                  text: "Signup",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500),
                                )
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
