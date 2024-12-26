import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterlingo/pages/bookPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> levels = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBooksGroupedByLevels();
  }

  Future<void> fetchBooksGroupedByLevels() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch books from Firestore and group them by their level attribute
      final booksSnapshot =
          await FirebaseFirestore.instance.collection('books').get();

      final Map<String, List<Map<String, dynamic>>> groupedBooks = {};

      // Group books by their 'level' attribute
      for (var bookDoc in booksSnapshot.docs) {
        final bookData = bookDoc.data();
        final level = bookData['level'];

        if (level != null) {
          // Ensure the level group exists
          if (!groupedBooks.containsKey(level)) {
            groupedBooks[level] = [];
          }

          groupedBooks[level]?.add({
            'id': bookDoc.id,
            'name': bookData['title'],
            // Add other book data if necessary
          });
        }
      }

      // Prepare levels data
      final List<Map<String, dynamic>> levelsData =
          groupedBooks.entries.map((entry) {
        return {
          'name': entry.key,
          'books': entry.value,
        };
      }).toList();

      setState(() {
        levels = levelsData;
      });
    } catch (e) {
      print('Error fetching books: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error logging out: $e",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToBookPages(String bookId) {
    // Navigate to the book pages screen, passing the bookId as a parameter
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BookPagesPage(bookId: bookId), // Make sure you define this screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Books by Level"),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ExpansionTile(
                    title: Text(
                      level['name'] ?? 'Unknown Level',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: level['books'].isNotEmpty
                        ? level['books'].map<Widget>((book) {
                            return ListTile(
                              title: Text(book['name'] ?? 'Unknown Book'),
                              onTap: () {
                                print(book['id']); // Print book id
                                _navigateToBookPages(
                                    book['id']); // Handle tap to navigate
                              }, // Handle tap to navigate
                            );
                          }).toList()
                        : [
                            const ListTile(
                              title: Text('No books assigned to this level'),
                            ),
                          ],
                  ),
                );
              },
            ),
    );
  }
}
