import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUserFavorite(String? userId, AltProduct product) async {
    if (userId == null) throw Exception('User ID is null');

    // Reference to the user's favourites document
    DocumentReference userFavouritesRef =
        _db.collection('favourites').doc(userId);

    // Add the product to the user's 'items' subcollection
    await userFavouritesRef.collection('items').add(product.toMap());
  }

  Future<void> removeUserFavorite(String? userId, AltProduct product) async {
    if (userId == null) throw Exception('User ID is null');

    // Reference to the user's favourites document
    DocumentReference userFavouritesRef =
        _db.collection('favourites').doc(userId);

    // Query the items subcollection for the document with the matching product details.
    QuerySnapshot snapshot = await userFavouritesRef
        .collection('items')
        .where('name', isEqualTo: product.name)
        .where('image', isEqualTo: product.image)
        .where('url', isEqualTo: product.url)
        .get();

    // If there's a document that matches, delete it.
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> addUserFavoriteVideo(String? userId, YtVideo video) async {
    if (userId == null) throw Exception('User ID is null');

    // Reference to the user's favourites document
    DocumentReference userFavouritesRef =
        _db.collection('favourites').doc(userId);

    // Add the video to the user's 'videos' subcollection
    await userFavouritesRef.collection('videos').add(video.toMap());
  }

  Future<void> removeUserFavoriteVideo(String? userId, YtVideo video) async {
    if (userId == null) throw Exception('User ID is null');

    // Reference to the user's favourites document
    DocumentReference userFavouritesRef =
        _db.collection('favourites').doc(userId);

    // Query the videos subcollection for the document with the matching video details.
    QuerySnapshot snapshot = await userFavouritesRef
        .collection('videos')
        .where('title', isEqualTo: video.title)
        .where('thumbnailUrl', isEqualTo: video.thumbnailUrl)
        .where('videoLink', isEqualTo: video.videoLink)
        .get();

    // If there's a document that matches, delete it.
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Stream<List<AltProduct>> streamUserFavoriteProducts(String userId) {
    return _db
        .collection('favourites')
        .doc(userId)
        .collection('items')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                AltProduct.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<YtVideo>> streamUserFavoriteVideos(String userId) {
    return _db
        .collection('favourites')
        .doc(userId)
        .collection('videos')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => YtVideo.fromJson(doc.data())).toList());
  }
}
