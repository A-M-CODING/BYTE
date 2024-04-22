// lib/features/community/widgets/post_widget.dart
import 'package:flutter/material.dart';
import 'package:byte_app/features/community/models/post_model.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byte_app/features/community/services/post_service.dart';
import 'package:byte_app/features/community/widgets/poll_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends StatefulWidget {
  final PostModel post;
  final Function(String, String) onVote;
  final VoidCallback onComment;
  final VoidCallback onLike;

  const PostWidget({
    Key? key,
    required this.post,
    required this.onVote,
    required this.onComment,
    required this.onLike,
  }) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late bool isLiked;
  late int likesCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.isLikedByCurrentUser; // Assuming this is passed from PostModel
    likesCount = widget.post.likes.length; // Assuming likes is a list of user IDs
  }

  void handleLike() {
    setState(() {
      isLiked = !isLiked; // Toggle like state optimistically
      // Update the count optimistically
      isLiked ? likesCount++ : likesCount--;
    });
    // Call the respective method based on new like state
    if (isLiked) {
      PostService().likePost(widget.post.id);
    } else {
      PostService().unlikePost(widget.post.id);
    }
  }

  String getFormattedTime(DateTime dateTime) {
    return timeago.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    // Determine post type
    bool isImagePost = widget.post.imageUrl.isNotEmpty;
    bool isPollPost = widget.post.options.isNotEmpty;
    bool isTextPost = !isImagePost && !isPollPost;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(), // Placeholder for user avatar
            title: Text(widget.post.userId, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(getFormattedTime(widget.post.timestamp)),
            isThreeLine: isImagePost, // Extra space for the image description
          ),
          if (isTextPost) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.post.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                  SizedBox(height: 8.0),
                  Text(widget.post.content),
                ],
              ),
            ),
          ],
          if (isImagePost) ...[
            Image.network(
              widget.post.imageUrl,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text('Could not load image'));
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.post.description),
            ),
          ],
          if (isPollPost) ...[
            PollWidget(
              question: widget.post.question,
              votes: widget.post.votes,
              options: widget.post.options,
              onVote: widget.onVote,
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                  color: isLiked ? Colors.red : null,
                  onPressed: handleLike, // Use local method to handle like
                ),
                Text('$likesCount likes'), // Display the locally managed count
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: widget.onComment,
                ),
                Text('View all ${widget.post.comments.length} comments'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
