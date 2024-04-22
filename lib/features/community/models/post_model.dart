// lib/features/community/model/post_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostModel {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String imageUrl; // For image posts
  final String description; // For image posts
  final String question; // For poll posts
  final DateTime timestamp;
  List<String> likes; // Now a list of user IDs
  final List<String> options; // For poll posts
  final List<dynamic> comments; // For holding comments or comment counts
  Map<String, int> votes;

  PostModel({
    required this.id,
    required this.userId,
    this.title = '',
    this.content = '',
    this.imageUrl = '',
    this.description = '',
    this.question = '',
    required this.timestamp,
    List<String>? likes,
    this.options = const [],
    this.comments = const [],
    Map<String, int>? votes, // Optional parameter for initializing votes
  })  : this.likes = likes ?? [],
        this.votes = votes ?? options.asMap().map((_, option) => MapEntry(option, 0));

  // Check if the current user has liked the post
  bool get isLikedByCurrentUser {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return currentUserId != null && likes.contains(currentUserId);
  }
  // Convert a PostModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'description': description,
      'question': question,
      'timestamp': timestamp,
      'likes': likes,
      'options': options,
      'comments': comments,
      'votes': votes,
    };
  }

  // Create a PostModel instance from a Firestore document
  factory PostModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final postType = data['type'] as String? ?? 'text'; // default to 'text' if not specified

    String title = '';
    String content = '';
    String imageUrl = '';
    String description = '';
    String question = '';
    List<String> options = [];

    // Assign values based on post type
    switch (postType) {
      case 'text':
        title = data['title'] as String? ?? 'No Title';
        content = data['content'] as String? ?? '';
        break;
      case 'image':
        imageUrl = data['imageUrl'] as String? ?? '';
        description = data['description'] as String? ?? '';
        break;
      case 'poll':
        question = data['question'] as String? ?? 'No Question';
        options = List<String>.from(data['options'] as List<dynamic>? ?? []);
        break;
      default:
      // Handle unknown type or implement a fallback
        break;
    }

    return PostModel(
      id: doc.id,
      userId: data['userId'] as String? ?? 'Unknown User',
      title: data['title'] as String? ?? '', // For text posts
      content: data['content'] as String? ?? '', // For text posts
      imageUrl: data['imageUrl'] as String? ?? '', // For image posts
      description: data['description'] as String? ?? '', // For image posts
      question: data['question'] as String? ?? '', // For poll posts
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(data['likes'] as List<dynamic>? ?? []),
      options: List<String>.from(data['options'] as List<dynamic>? ?? []),
      comments: data['comments'] as List<dynamic>? ?? [],
      votes: data['votes'] != null ? Map<String, int>.from(data['votes']) : {},
    );
  }
  void toggleLike(String userId) {
    if (isLikedByCurrentUser) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }
  }
}
