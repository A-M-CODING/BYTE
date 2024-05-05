// lib/features/community/services/post_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:byte_app/features/community/models/post_model.dart'; // Update the import path

class PostService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<PostModel?> getPostById(String postId) async {
    try {
      DocumentSnapshot postSnapshot = await _firestore.collection('posts').doc(postId).get();
      if (postSnapshot.exists) {
        // Create and return the PostModel using the data from Firestore
        return PostModel.fromDocument(postSnapshot);
      } else {
        print('Post not found!');
        return null;
      }
    } catch (e) {
      print('Error fetching post by ID: $e');
      return null;
    }
  }


  Future<void> likePost(String postId) async {
    String userId = _auth.currentUser!.uid; // Get the current user's ID
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot postSnapshot = await transaction.get(postRef);
      if (postSnapshot.exists) {
        List<dynamic> likes = (postSnapshot.data() as Map<String, dynamic>)['likes'] ?? [];
        if (!likes.contains(userId)) {
          transaction.update(postRef, {'likes': FieldValue.arrayUnion([userId])});
        }
      }
    });
  }

  Future<void> unlikePost(String postId) async {
    String userId = _auth.currentUser!.uid; // Get the current user's ID
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot postSnapshot = await transaction.get(postRef);
      if (postSnapshot.exists) {
        List<dynamic> likes = (postSnapshot.data() as Map<String, dynamic>)['likes'] ?? [];
        if (likes.contains(userId)) {
          transaction.update(postRef, {'likes': FieldValue.arrayRemove([userId])});
        }
      }
    });
  }
  // Optimistic update for voting on a poll option
  Future<void> voteOnOption(String postId, String option) async {
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot postSnapshot = await transaction.get(postRef);
      if (postSnapshot.exists) {
        Map<String, dynamic> data = postSnapshot.data() as Map<String, dynamic>;
        Map<String, int> currentVotes = Map<String, int>.from(data['votes'] ?? {});
        currentVotes.update(option, (value) => value + 1, ifAbsent: () => 1);
        transaction.update(postRef, {'votes': currentVotes});
      }
    });
  }
}