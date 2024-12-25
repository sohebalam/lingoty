import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterlingo/components/helper_func.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          // Handling errors
          if (snapshot.hasError) {
            displayMessageToUser('Something went wrong', context);
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          // Waiting for data to load
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // No data case
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No data'),
            );
          }

          // If data is available
          final users = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return ListTile(
                      title: Text(user['email']),
                      subtitle: Text(
                        user['isAdmin'] == true ? 'Admin' : 'Not an Admin',
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
