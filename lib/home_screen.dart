import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterlingo/model/auth_model.dart';
import 'package:flutterlingo/provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider =
        Provider.of<UserProvider>(context, listen: false).getUserData();

    return FutureBuilder<AuthModel>(
        future: userProvider,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.data!.email),
                  Text(snapshot.data!.name),
                  Text(snapshot.data!.id)
                ],
              ),
            ),
          );
        });
  }
}
