// lib/features/community/services/comment_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:byte_app/features/community/models/comment_model.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch comments for a specific post
  Stream<List<CommentModel>> fetchComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CommentModel.fromDocument(doc)).toList();
    });
  }

  // Add a new comment to a specific post optimistically
  Future<void> addCommentOptimistically(String postId, String userId, String content, List<CommentModel> comments, Function onError) async {
    final DocumentReference postRef = _firestore.collection('posts').doc(postId);
    final newCommentRef = postRef.collection('comments').doc();

    CommentModel newComment = CommentModel(
      id: newCommentRef.id, // Generate a new document ID
      userId: userId,
      content: content,
      timestamp: DateTime.now(),
    );

    // Optimistically add the comment to the local state
    comments.insert(0, newComment);

    try {
      await newCommentRef.set(newComment.toMap());
    } catch (e) {
      onError();
      comments.remove(newComment); // Revert the optimistic update if an error occurs
    }
  }

  // Add a reply to a comment optimistically
  Future<void> addReplyOptimistically(String postId, String commentId, String userId, String content, List<CommentModel> replies, Function onError) async {
    final DocumentReference commentRef = _firestore.collection('posts').doc(postId).collection('comments').doc(commentId);
    final newReplyRef = commentRef.collection('replies').doc();

    CommentModel newReply = CommentModel(
      id: newReplyRef.id,
      userId: userId,
      content: content,
      timestamp: DateTime.now(),
      parentId: commentId,
    );

    // Optimistically add the reply to the local state
    replies.insert(0, newReply);

    try {
      await newReplyRef.set(newReply.toMap());
    } catch (e) {
      onError();
      replies.remove(newReply); // Revert the optimistic update if an error occurs
    }
  }

  // Fetch replies for a specific comment
  Stream<List<CommentModel>> fetchReplies(String commentId, String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CommentModel.fromDocument(doc)).toList();
    });
  }
}