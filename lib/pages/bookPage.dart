import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookPagesPage extends StatefulWidget {
  final String bookId;

  const BookPagesPage({required this.bookId, super.key});

  @override
  _BookPagesPageState createState() => _BookPagesPageState();
}

class _BookPagesPageState extends State<BookPagesPage> {
  final Stream<bool> isLoggedInStream =
      FirebaseAuth.instance.authStateChanges().map((user) => user != null);

  List<Map<String, dynamic>> pages = [];
  int currentPage = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookDetails(); // Fetch book details and pages from Firestore
  }

  // Fetch book details and its pages from Firestore
  Future<void> fetchBookDetails() async {
    try {
      setState(() => isLoading = true);

      // Fetch the book data from Firestore using the bookId
      final bookRef =
          FirebaseFirestore.instance.collection('books').doc(widget.bookId);
      final bookSnap = await bookRef.get();

      if (!bookSnap.exists) {
        setState(() => isLoading = false);
        print('Book not found for ID: ${widget.bookId}');
        return;
      }

      // Extract book data
      final bookData = bookSnap.data();
      if (bookData == null || !bookData.containsKey('pages')) {
        setState(() => isLoading = false);
        print('No pages found for this book.');
        return;
      }

      // Check if the pages field exists and is a List
      if (bookData['pages'] is List) {
        final pagesData =
            List<Map<String, dynamic>>.from(bookData['pages'].map((page) {
          return {
            'id': page['id'] ?? '',
            'image': page['image'] ?? '',
            'translations': page['translations'] ?? [],
          };
        }));

        setState(() {
          pages = pagesData;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('No valid pages array found in book data.');
      }
    } catch (e) {
      print('Error fetching book details: $e');
      setState(() => isLoading = false);
    }
  }

  void _nextPage() {
    if (currentPage < pages.length - 1) {
      setState(() => currentPage++);
    }
  }

  void _prevPage() {
    if (currentPage > 0) {
      setState(() => currentPage--);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Book Pages')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (pages.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Book Pages')),
        body: const Center(child: Text('No pages available for this book.')),
      );
    }

    final page = pages[currentPage];

    return Scaffold(
      appBar: (MediaQuery.of(context).orientation == Orientation.portrait)
          ? AppBar(title: const Text('Book Pages'))
          : null, // Hide AppBar in landscape mode
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLandscape = constraints.maxWidth > constraints.maxHeight;

          return isLandscape
              // Use Row layout for landscape mode (side by side)
              ? Row(
                  children: [
                    // Image section (left half)
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: page['image'].isNotEmpty
                            ? Image.network(
                                page['image'],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      'assets/fallback_image.jpeg');
                                },
                              )
                            : Image.asset('assets/fallback_image.jpeg'),
                      ),
                    ),
                    // Translations section (right half)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Translations:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              ...List.generate(
                                page['translations'].length,
                                (index) {
                                  final translation =
                                      page['translations'][index];
                                  final text = translation['text'] ??
                                      'No translation available.';
                                  final language = translation['language'] ??
                                      'Unknown Language';
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      '$language: $text',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              // Use Column layout for portrait mode (stacked)
              : Column(
                  children: [
                    // Image section
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: page['image'].isNotEmpty
                            ? Image.network(
                                page['image'],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      'assets/fallback_image.jpeg');
                                },
                              )
                            : Image.asset('assets/fallback_image.jpeg'),
                      ),
                    ),
                    // Translations section
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Translations:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                ...List.generate(
                                  page['translations'].length,
                                  (index) {
                                    final translation =
                                        page['translations'][index];
                                    final text = translation['text'] ??
                                        'No translation available.';
                                    final language = translation['language'] ??
                                        'Unknown Language';
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        '$language: $text',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 32),
              color: currentPage > 0 ? Colors.blue : Colors.grey,
              onPressed: currentPage > 0 ? _prevPage : null,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward, size: 32),
              color: currentPage < pages.length - 1 ? Colors.blue : Colors.grey,
              onPressed: currentPage < pages.length - 1 ? _nextPage : null,
            ),
          ],
        ),
      ),
    );
  }
}
