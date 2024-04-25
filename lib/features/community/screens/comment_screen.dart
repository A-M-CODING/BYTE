// lib/features/community/screens/comment_screen.dart
import 'package:flutter/material.dart';
import 'package:byte_app/features/community/models/comment_model.dart';
import 'package:byte_app/features/community/services/comment_service.dart';
import 'package:intl/intl.dart';
<<<<<<< HEAD
=======
import 'package:firebase_auth/firebase_auth.dart';
>>>>>>> fe279d9 (Updated community features)

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
<<<<<<< HEAD
=======
  String? currentUsername;
>>>>>>> fe279d9 (Updated community features)

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
=======
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Assuming that you want to use the part of the email before '@' as the username
      currentUsername = currentUser.email!.split('@').first;
    }
>>>>>>> fe279d9 (Updated community features)
    _commentService.fetchComments(widget.postId).listen((commentList) {
      setState(() {
        comments = commentList;
      });
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
<<<<<<< HEAD
    String currentUserId = 'some_user_id'; // TODO: Retrieve the actual user ID
    _commentService.addCommentOptimistically(
      widget.postId,
      currentUserId,
      content,
      comments,
          () => setState(() {
        // This callback is called if there's an error
        comments.removeAt(0); // Assuming the new comment is at the top
      }),
    );
    setState(() {
      // Add to local state
      comments.insert(0, CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID
        userId: currentUserId,
=======
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
>>>>>>> fe279d9 (Updated community features)
        content: content,
        timestamp: DateTime.now(),
      ));
    });
  }

<<<<<<< HEAD
  void _addReplyOptimistically(String content) {
    if (_replyingToCommentId == null) return;
    String currentUserId = 'some_user_id'; // TODO: Retrieve the actual user ID

    // Check if the reply is already being processed
    if (repliesMap[_replyingToCommentId]!.any((reply) => reply.content == content && reply.userId == currentUserId)) {
      return;
    }

    List<CommentModel> replies = repliesMap[_replyingToCommentId] ?? [];
    _commentService.addReplyOptimistically(
      widget.postId,
      _replyingToCommentId!,
      currentUserId,
      content,
      replies,
          () => setState(() {
        // Error callback
        replies.removeWhere((reply) => reply.content == content && reply.userId == currentUserId);
      }),
    );
    setState(() {
      // Add to local state
      replies.insert(0, CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID
        userId: currentUserId,
        content: content,
        timestamp: DateTime.now(),
        parentId: _replyingToCommentId,
      ));
      repliesMap[_replyingToCommentId!] = replies;
    });
  }

=======
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
      // If there was an error, remove the optimistic reply
      setState(() {
        repliesMap[_replyingToCommentId]?.removeWhere((reply) => reply.id == tempId);
      });
      // Optionally, show an error message to the user
    });
  }



>>>>>>> fe279d9 (Updated community features)
  Widget _buildReplyTextField() {
    if (!_isReplying) return SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _commentController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Write a reply...',
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              final String content = _commentController.text;
              if (content.trim().isNotEmpty) {
                _addReplyOptimistically(content);
                _commentController.clear();
                _stopReplying();
              }
            },
          ),
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            _addReplyOptimistically(value);
            _commentController.clear();
            _stopReplying();
          }
        },
      ),
    );
  }

  Widget _buildCommentWithReplies(CommentModel comment, BuildContext context) {
    List<CommentModel> replies = repliesMap[comment.id] ?? [];
    bool isRepliesVisible = _repliesVisibility[comment.id] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCommentListTile(comment, context),
        TextButton(
          onPressed: () {
            if (repliesMap[comment.id] == null) {
              _commentService.fetchReplies(comment.id, widget.postId).listen((replyList) {
                setState(() {
                  repliesMap[comment.id] = replyList;
                  // Ensure that visibility is toggled only after replies are fetched
                  _toggleRepliesVisibility(comment.id);
                });
              });
            } else {
              // Directly toggle visibility if replies are already fetched
              _toggleRepliesVisibility(comment.id);
            }
          },
          child: Text(isRepliesVisible ? 'Hide replies' : 'View replies'),
        ),
        if (isRepliesVisible)
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: replies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: _buildCommentListTile(replies[index], context),
              );
            },
          ),
      ],
    );
  }

  void _toggleRepliesVisibility(String commentId) {
    setState(() {
      _repliesVisibility[commentId] = !(_repliesVisibility[commentId] ?? false);
    });
  }

  Widget _buildCommentListTile(CommentModel comment, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(), // Placeholder for user avatar
          title: Text(comment.userId),
          subtitle: Text(comment.content),
          trailing: Text(
            DateFormat('dd MMM yyyy HH:mm').format(comment.timestamp),
            style: Theme.of(context).textTheme.caption,
          ),
          isThreeLine: true,
        ),
        Row(
          children: <Widget>[
            if (comment.parentId == null) // Only show reply button for top-level comments
              TextButton(
                onPressed: () => _startReplyToComment(comment.id),
                child: Text('Reply', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
              ),
          ],
        ),

        _isReplying && _replyingToCommentId == comment.id ? _buildReplyTextField() : SizedBox(),
      ],
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
                hintText: 'Write a comment...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              final String content = _commentController.text;
              if (content.trim().isNotEmpty) {
                _addCommentOptimistically(content);
                _commentController.clear();
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
