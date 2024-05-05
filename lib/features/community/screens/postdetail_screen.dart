// lib/features/community/screens/postdetail_screen.dart

import 'package:flutter/material.dart';
import 'package:byte_app/features/community/models/post_model.dart';
import 'package:byte_app/features/community/services/post_service.dart';
import 'package:byte_app/features/community/widgets/post_widget.dart';
import 'package:byte_app/features/community/screens/comment_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PostModel? post;
  bool isLoading = true;
  final PostService _postService = PostService();

  @override
  void initState() {
    super.initState();
    _fetchPost();
  }
  void refreshPost() {
    _fetchPost();  // This will re-fetch the post details including updated comments count
  }


  Future<void> _fetchPost() async {
    try {
      post = await PostService().getPostById(widget.postId);
      setState(() => isLoading = false);
    } catch (e) {
      print('Error fetching post: $e');
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (post == null) {
      return Scaffold(body: Center(child: Text('Post not found')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(post!.title), // Assuming PostModel has a title
      ),
      body: SingleChildScrollView(
        child: PostWidget(
          // Pass the fetched post to the PostWidget
          post: post!,
          onLike: () {},
          onComment: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommentsScreen(postId: post!.id),
              ),
            ).then((_) => refreshPost());  // Add then method with refreshPost
          },

          onVote: (String question, String option) async {
            await _postService.voteOnOption(question, option);
          },
          profileImage: post!.authorProfileImage,
        ),
      ),
    );
  }
}
