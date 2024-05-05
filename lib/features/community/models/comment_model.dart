// lib/features/community/models/comment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String userId;
  final String content;
  final DateTime timestamp;
  final String? parentId;

  CommentModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    this.parentId,
  });

  // Convert a CommentModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'parentId': parentId,
    };
  }

  // Create a CommentModel instance from a Firestore document
  factory CommentModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return CommentModel(
      id: doc.id,
      userId: data['userId'] as String? ?? 'Unknown User',
      content: data['content'] as String? ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      parentId: data['parentId'] as String?,
    );
  }
}