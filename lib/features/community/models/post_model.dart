// lib/features/community/model/post_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostModel {
  final String id;
  final String userId;
  final String topic;
  final String title;
  final String content;
  final String imageUrl; // For image posts
  final String description; // For image posts
  final String question; // For poll posts
  final DateTime timestamp;
  List<String> likes; // Now a list of user IDs
  final List<String> options; // For poll posts
  final int commentsCount; // For holding comments or comment counts
  Map<String, List<String>> votes;
  final String authorProfileImage;
  final List<String> categories;

  PostModel({
    required this.id,
    required this.userId,
    this.topic = '',
    this.title = '',
    this.content = '',
    this.imageUrl = '',
    this.description = '',
    this.question = '',
    required this.timestamp,
    List<String>? likes,
    required this.authorProfileImage,
    required this.categories,
    this.options = const [],
    this.commentsCount = 0,
    Map<String, List<String>>? votes,  // Optional parameter for initializing votes
  })  : this.likes = likes ?? [],
        this.votes = votes ?? options.asMap().map((_, option) => MapEntry(option, []));

  // Check if the current user has liked the post
  bool get isLikedByCurrentUser {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return currentUserId != null && likes.contains(currentUserId);
  }
  // Convert a PostModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'topic': topic,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'description': description,
      'question': question,
      'timestamp': timestamp,
      'likes': likes,
      'options': options,
      'commentsCount': commentsCount,
      'votes': votes,
      'categories': categories,
    };
  }

  // Create a PostModel instance from a Firestore document
  factory PostModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final postType = data['type'] as String? ?? 'text'; // default to 'text' if not specified

    // Parse votes to ensure correct format
    Map<String, List<String>> parsedVotes = {};
    if (data['votes'] != null) {
      parsedVotes = (data['votes'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, List<String>.from(value)),
      );
    }

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
      topic: data['topic'] as String? ?? 'No Topic',
      title: data['title'] as String? ?? '', // For text posts
      content: data['content'] as String? ?? '', // For text posts
      imageUrl: data['imageUrl'] as String? ?? '', // For image posts
      description: data['description'] as String? ?? '', // For image posts
      question: data['question'] as String? ?? '', // For poll posts
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(data['likes'] as List<dynamic>? ?? []),
      options: List<String>.from(data['options'] as List<dynamic>? ?? []),
      commentsCount: data['commentsCount'] as int? ?? 0,
      authorProfileImage: data['userProfileImage'] as String? ?? 'assets/images/default_profile.png', // Extract profile image URL
      categories: List<String>.from(data['categories'] as List<dynamic>? ?? []), // Parse categories from the document
      votes: parsedVotes,
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
