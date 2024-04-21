import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUserFavorite(String? userId, AltProduct product) async {
    await _db
        .collection('favourites')
        .doc('user')
        .collection('items')
        .add(product.toMap());
  }

  Future<void> removeUserFavorite(String? userId, AltProduct product) async {
    // Query the items subcollection for the document with the matching product details.
    var snapshot = await _db
        .collection('favourites')
        .doc('user')
        .collection('items')
        .where('name', isEqualTo: product.name)
        .where('image', isEqualTo: product.image)
        .where('url', isEqualTo: product.url)
        .limit(1)
        .get();

    // If there's a document that matches, delete it.
    if (snapshot.docs.isNotEmpty) {
      await _db
          .collection('favourites')
          .doc('user')
          .collection('items')
          .doc(snapshot.docs.first.id)
          .delete();
    }
  }

  // Similarly update the methods for videos
  // ...
}
