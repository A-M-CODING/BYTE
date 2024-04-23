// lib/features/community/screens/feed.dart

import 'package:flutter/material.dart';
import 'package:byte_app/features/community/models/post_model.dart';
import 'package:byte_app/features/community/widgets/post_widget.dart';
import 'package:byte_app/features/community/services/post_service.dart';
import 'package:byte_app/features/community/screens/comment_screen.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PostService _postService = PostService();


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Implement category filter
            },
          ),
        ],
      ),
      body: StreamBuilder<List<PostModel>>(
        stream: _postService.fetchAllPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts found'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              // Use ValueKey to optimize rebuilds of list items
              return PostWidget(
                key: ValueKey(post.id),
                post: post,
                onLike:(){

                },

                onComment: () {
                  // Use the post ID to navigate to the comments screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommentsScreen(postId: post.id)),
                  );
                },
                onVote: (String question, String option) async {
                  await _postService.voteOnOption(question, option);
                  // Optionally, manage state updates if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}
