import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterlingo/auth/login_screen.dart';
import 'package:flutterlingo/auth/widgets/custom_button.dart';
import 'package:flutterlingo/auth/widgets/custom_textfield.dart';
import 'package:flutterlingo/home_screen.dart';
import 'package:flutterlingo/provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  void loginNavigator() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  bool isPassword = false;
  bool isCheckBox = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  Future<void> signUp() async {
    final signProvider = Provider.of<UserProvider>(context, listen: false);
    await signProvider.signUp(
        nameController.text, passwordController.text, emailController.text);
    homeNavigator();
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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: SingleChildScrollView(
            child: authProvider.isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      SizedBox(
                        height: 250,
                        child: Image.asset("assets/signup.png"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextfield(
                          hintText: "Name",
                          textEditingController: nameController,
                          prefixIcon: Icons.email_outlined),
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
                        height: 10,
                      ),
                      CustomButton(
                        width: double.infinity,
                        buttonText: "SIGNUP",
                        onPressed: signUp,
                      ),
                      SizedBox(
                        height: size.height * 0.10,
                      ),
                      GestureDetector(
                        onTap: loginNavigator,
                        child: RichText(
                          text: const TextSpan(
                              text: "Already have an account? ",
                              children: [
                                TextSpan(
                                  text: "Login",
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
