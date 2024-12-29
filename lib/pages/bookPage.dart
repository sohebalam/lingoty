import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Ensure this package is added in pubspec.yaml

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
  String bookName = 'Loading...';
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

      final bookRef =
          FirebaseFirestore.instance.collection('books').doc(widget.bookId);
      final bookSnap = await bookRef.get();

      if (!bookSnap.exists) {
        setState(() {
          isLoading = false;
          bookName = 'Book not found';
        });
        return;
      }

      final bookData = bookSnap.data();
      if (bookData == null) {
        setState(() {
          isLoading = false;
          bookName = 'No book data available';
        });
        return;
      }

      setState(() {
        bookName = bookData['title'] ?? 'Book';
      });

      if (bookData.containsKey('pages') && bookData['pages'] is List) {
        final pagesData =
            List<Map<String, dynamic>>.from(bookData['pages'].map((page) {
          return {
            'id': page['id'] ?? '',
            'image': page['image'] ?? '',
            'translations': page['translations'] ?? [],
            'isCover': page['isCover'] ?? false, // Adding isCover flag
          };
        }));

        setState(() {
          pages = pagesData;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          pages = [];
        });
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
    return Scaffold(
      appBar: AppBar(
        title: Text(bookName),
      ),
      body: isLoading
          ? Skeletonizer(
              enabled: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey[400], // Skeleton color
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        itemCount: 5, // Placeholder for translations
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              height: 20.0,
                              color: Colors.grey[400], // Skeleton color
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : pages.isEmpty
              ? const Center(
                  child: Text('No pages available for this book.'),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    bool isLandscape =
                        constraints.maxWidth > constraints.maxHeight;

                    return isLandscape
                        ? Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: FutureBuilder(
                                    future:
                                        _loadImage(pages[currentPage]['image']),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Skeletonizer(
                                          enabled: true,
                                          child: Container(
                                            color: Colors
                                                .grey[400], // Skeleton color
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Image.asset(
                                            'images/fallback_image.jpeg');
                                      } else {
                                        return Image.network(
                                          pages[currentPage]['image'],
                                          fit: BoxFit.cover,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              if (!pages[currentPage]['isCover']) ...[
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ...List.generate(
                                            pages[currentPage]['translations']
                                                .length,
                                            (index) {
                                              final translation =
                                                  pages[currentPage]
                                                      ['translations'][index];
                                              final text = translation[
                                                      'text'] ??
                                                  'No translation available.';
                                              final language =
                                                  translation['language'] ??
                                                      'Unknown Language';
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: Text(
                                                  '$text',
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
                            ],
                          )
                        : Column(
                            children: [
                              // Image section
                              Expanded(
                                flex: 1, // Top half of the screen for the image
                                child: Center(
                                  child: FutureBuilder(
                                    future:
                                        _loadImage(pages[currentPage]['image']),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Skeletonizer(
                                          enabled: true,
                                          child: Container(
                                            color: Colors
                                                .grey[400], // Skeleton color
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Image.asset(
                                            'images/fallback_image.jpeg');
                                      } else {
                                        return Image.network(
                                          pages[currentPage]['image'],
                                          fit: BoxFit.cover,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),

                              // Text section - Translations
                              if (!pages[currentPage]['isCover']) ...[
                                Expanded(
                                  flex:
                                      1, // Bottom half of the screen for the text
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center, // Vertically center the text
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center, // Horizontally center the text
                                          children: [
                                            // Loop through translations and display them
                                            ...List.generate(
                                              pages[currentPage]['translations']
                                                  .length,
                                              (index) {
                                                final translation =
                                                    pages[currentPage]
                                                        ['translations'][index];
                                                final text = translation[
                                                        'text'] ??
                                                    'No translation available.';
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4.0),
                                                  child: Text(
                                                    '$text',
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

  Future<void> _loadImage(String url) async {
    await precacheImage(NetworkImage(url), context);
  }
}
