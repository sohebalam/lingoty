import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
// get Collection of Books

  final CollectionReference levels =
      FirebaseFirestore.instance.collection('levels');

// Create new levels/books/pages/
  Future<void> addLevel(String level) {
    return levels.add({
      'name': level, // 'level' should be a string key
    });
  }

//Read get levels/books from the DB

  Stream<QuerySnapshot> getLevelsStream() {
    final levelsStream = levels.snapshots();

    return levelsStream;
  }
//update level/books give and doc id

  Future<void> updateLevel(String docId, String newLevel) {
    return levels.doc(docId).update({'name': newLevel});
  }

//Delete level given doc id
  Future<void> deleteLevel(String docId) {
    return levels.doc(docId).delete();
  }
}
