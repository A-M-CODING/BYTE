// lib/features/community/screens/comment_screen.dart
import 'package:flutter/material.dart';
import 'package:byte_app/features/community/models/comment_model.dart';
import 'package:byte_app/features/community/services/comment_service.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:byte_app/app_theme.dart';


class CommentsScreen extends StatefulWidget {
  final String postId;

  CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final CommentService _commentService = CommentService();
  final TextEditingController _commentController = TextEditingController();
  bool _isReplying = false;
  String? _replyingToCommentId;
  Map<String, List<CommentModel>> repliesMap = {};
  List<CommentModel> comments = [];
  Map<String, bool> _repliesVisibility = {};
  String? currentUsername;
  Map<String, int> _repliesCountMap = {};

  @override
  void initState() {
    super.initState();
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUsername = currentUser.email!.split('@').first;
    }
    _commentService.fetchComments(widget.postId).listen((commentList) {
      setState(() {
        comments = commentList;
      });
      // Fetch the replies count for each comment
      for (var comment in comments) {
        _commentService.fetchRepliesCount(comment.id, widget.postId).then((count) {
          setState(() {
            _repliesCountMap[comment.id] = count;
          });
        });
      }
    });
  }

  void _startReplyToComment(String commentId) {
    setState(() {
      _replyingToCommentId = commentId;
      _isReplying = true;
    });
  }

  void _stopReplying() {
    setState(() {
      _replyingToCommentId = null;
      _isReplying = false;
    });
  }

  void _addCommentOptimistically(String content) {
    if (currentUsername == null) return;  // Ensure the username is not null
    _commentService.addCommentOptimistically(
      widget.postId,
      currentUsername!,
      content,
      comments,
          () => setState(() {
        comments.removeAt(0);  // Assuming the new comment is at the top
      }),
    );
    setState(() {
      comments.insert(0, CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),  // Temp ID
        userId: currentUsername!,
        content: content,
        timestamp: DateTime.now(),
      ));
    });
  }

  // In your _CommentsScreenState class

  void _addReplyOptimistically(String content) {
    if (_replyingToCommentId == null || currentUsername == null) return;

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    CommentModel optimisticReply = CommentModel(
      id: tempId,
      userId: currentUsername!,
      content: content,
      timestamp: DateTime.now(),
      parentId: _replyingToCommentId,
    );

    // Add the optimistic reply to the local state
    setState(() {
      repliesMap.update(
        _replyingToCommentId!,
            (replies) => [optimisticReply, ...replies],
        ifAbsent: () => [optimisticReply],
      );
      // Update the replies count map
      _repliesCountMap[_replyingToCommentId!] = (_repliesCountMap[_replyingToCommentId] ?? 0) + 1;
    });

    // Now, try to add the reply to Firestore
    _commentService.addReply(widget.postId, _replyingToCommentId!, currentUsername!, content).then((replyId) {
      setState(() {
        // Replace the whole CommentModel with the one containing the server-generated ID
        final index = repliesMap[_replyingToCommentId]!.indexWhere((reply) => reply.id == tempId);
        if (index != -1) {
          repliesMap[_replyingToCommentId]![index] = CommentModel(
            id: replyId,
            userId: currentUsername!,
            content: content,
            timestamp: optimisticReply.timestamp, // Preserve the original timestamp
            parentId: _replyingToCommentId,
          );
        }
      });
    }).catchError((error) {
      // If there was an error, remove the optimistic reply and decrement the replies count
      setState(() {
        repliesMap[_replyingToCommentId]?.removeWhere((reply) => reply.id == tempId);
        _repliesCountMap[_replyingToCommentId!] = (_repliesCountMap[_replyingToCommentId] ?? 1) - 1;
      });
      // Optionally, show an error message to the user
    });
  }


  Widget _buildCommentWithReplies(CommentModel comment, BuildContext context) {
    List<CommentModel> replies = repliesMap[comment.id] ?? [];
    bool isRepliesVisible = _repliesVisibility[comment.id] ?? false;
    bool hasReplies = (_repliesCountMap[comment.id] ?? 0) > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCommentListTile(comment, context),
        if (hasReplies)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: TextButton(
              onPressed: () {
                _toggleRepliesVisibility(comment.id);
                if (replies.isEmpty) {
                  _commentService.fetchReplies(comment.id, widget.postId).listen((replyList) {
                    setState(() {
                      repliesMap[comment.id] = replyList;
                    });
                  });
                }
              },
              child: Text(isRepliesVisible ? 'Hide replies' : 'View replies (${_repliesCountMap[comment.id]})'),
            ),
          ),
        if (isRepliesVisible)
          ...replies.map((reply) => _buildCommentListTile(reply, context, isReply: true)),
      ],
    );
  }


  void _toggleRepliesVisibility(String commentId) {
    setState(() {
      _repliesVisibility[commentId] = !(_repliesVisibility[commentId] ?? false);
    });
  }

  Widget _buildCommentListTile(CommentModel comment, BuildContext context, {bool isReply = false}) {
    String imagePath = isReply ? 'assets/icons/comments/reply.jpg' : 'assets/icons/comments/comment.jpg';
    AppTheme theme = AppTheme.of(context); // Access the theme

    return Padding(
      padding: EdgeInsets.only(left: isReply ? 20.0 : 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(imagePath), // Use AssetImage to load from local assets
              backgroundColor: Colors.transparent,
            ),
            title: Text(
                comment.userId,
                style: theme.typography.subtitle22.copyWith(fontWeight: FontWeight.bold) // Bold for usernames
            ),
            subtitle: Text(
                comment.content,
                style: theme.typography.subtitle22 // Regular style for content
            ),
            isThreeLine: true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isReply)
                TextButton(
                  onPressed: () => _startReplyToComment(comment.id),
                  child: Text('Reply', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                ),
                Text(
                  timeago.format(comment.timestamp),
                  style: theme.typography.bodyText11
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCommentInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: _isReplying ? 'Write a reply...' : 'Write a comment...',
                border: InputBorder.none,
              ),
            ),
          ),
          if (_isReplying)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isReplying = false;
                  _replyingToCommentId = null;
                  _commentController.clear();
                });
              },
            ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              final String content = _commentController.text;
              if (content.trim().isNotEmpty) {
                if (_isReplying) {
                  _addReplyOptimistically(content);
                } else {
                  _addCommentOptimistically(content);
                }
                _commentController.clear();
                if (_isReplying) {
                  _stopReplying();
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return _buildCommentWithReplies(comments[index], context);
              },
            ),
          ),
          Divider(height: 1),
          _buildCommentInput(context),
        ],
      ),
    );
  }
}