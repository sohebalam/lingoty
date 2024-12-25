import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    if (currentUser == null) {
      throw Exception("User is not logged in.");
    }
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Profle Page'),
      // ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data!.data();
            return Stack(
              children: [
                // Positioned back button at the top left
                const Positioned(
                  top: 50,
                  left: 25,
                  child: BackButton(),
                ),

                // Centered content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.all(25),
                        child: const Icon(
                          Icons.person,
                          size: 68,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        user!['email'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        user['isAdmin'] == true ? 'Admin' : 'Not an Admin',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }
}
