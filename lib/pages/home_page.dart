import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterlingo/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// text controller
final TextEditingController textController = TextEditingController();
final FirestoreService firestoreService = FirestoreService();

class _HomePageState extends State<HomePage> {
  void openLevelBox({String? docId}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    final text = textController.text;

                    if (docId == null) {
                      print('Add button clicked. Text entered: $text'); // Debug
                      if (text.isNotEmpty) {
                        if (docId == null) {}
                        firestoreService.addLevel(text).then((_) {
                          print('Level added successfully: $text'); // Debug
                        }).catchError((error) {
                          print('Failed to add level: $error'); // Debug
                        });
                        textController.clear();
                        Navigator.pop(context);
                      } else {
                        print('Text field is empty. No action taken.'); // Debug
                      }
                    } else {
                      firestoreService.updateLevel(docId, textController.text);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(docId == null ? 'Add' : 'Update'),
                ),
              ],
            ));
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Levels'),
          actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: openLevelBox,
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getLevelsStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No levels found'));
            } else {
              List<DocumentSnapshot> levelsList = snapshot.data!.docs;

              return ListView.builder(
                itemCount: levelsList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = levelsList[index];
                  String docId = document.id;

                  // Cast document data to Map<String, dynamic>
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String levelText =
                      data['name'] ?? 'Unnamed Level'; // Handle null values

                  return ListTile(
                      title: Text(levelText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                openLevelBox(docId: docId);
                                print('Selected Level ID: $docId');
                              },
                              icon: const Icon(Icons.settings)),
                          IconButton(
                            onPressed: () {
                              // Show confirmation dialog before deleting
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: const Text(
                                      'Are you sure you want to delete this level?'),
                                  actions: <Widget>[
                                    // Cancel button
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog without doing anything
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    // Confirm button
                                    TextButton(
                                      onPressed: () {
                                        firestoreService.deleteLevel(docId);
                                        print(
                                            'Selected Level ID: $docId'); // Debug: Show the deleted level ID
                                        Navigator.pop(
                                            context); // Close the dialog after confirming
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ));
                },
              );
            }
          },
        ));
  }
}
