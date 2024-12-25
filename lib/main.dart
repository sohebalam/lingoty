import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterlingo/services/auth/auth.dart';
import 'package:flutterlingo/services/auth/login_or_reg.dart';
import 'package:flutterlingo/firebase_options.dart';
import 'package:flutterlingo/pages/home_page.dart';
import 'package:flutterlingo/theme/darkmode.dart';
import 'package:flutterlingo/theme/lightmode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Auth(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
