import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterlingo/pages/home.dart';
import 'package:flutterlingo/pages/signin.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  registration() async {
    if (password.isNotEmpty && email.isNotEmpty && name.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Registered Successfully",
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'weak-password') {
          message = "Password Provided is too weak";
        } else if (e.code == "email-already-in-use") {
          message = "Account Already exists";
        } else {
          message = "An error occurred";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            message,
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: const AssetImage("images/account.png"),
                      height: size.height * 0.2,
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),

                const SizedBox(height: 20.0),

                // Form Section
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: namecontroller,
                        decoration: InputDecoration(
                          label: const Text("Full Name"),
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          border: const OutlineInputBorder(),
                          prefixIconColor: Theme.of(context).primaryColor,
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        // style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: mailcontroller,
                        decoration: InputDecoration(
                          label: const Text("Email"),
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: const OutlineInputBorder(),
                          prefixIconColor: Theme.of(context).primaryColor,
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        // style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: passwordcontroller,
                        decoration: InputDecoration(
                          label: const Text("Password"),
                          prefixIcon: const Icon(Icons.fingerprint),
                          border: const OutlineInputBorder(),
                          prefixIconColor: Theme.of(context).primaryColor,
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        obscureText: true,
                        // style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 30.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (namecontroller.text.isNotEmpty &&
                                mailcontroller.text.isNotEmpty &&
                                passwordcontroller.text.isNotEmpty) {
                              setState(() {
                                email = mailcontroller.text;
                                name = namecontroller.text;
                                password = passwordcontroller.text;
                              });
                              registration();
                            }
                          },
                          child: const Text("SIGN UP"),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20.0),

                // Footer Section
                Column(
                  children: [
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignIn()));
                        },
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                            text: "Already have an account? ",
                            // style: Theme.of(context).textTheme.bodyText1,
                          ),
                          TextSpan(
                            text: "LOGIN",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          )
                        ])),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
