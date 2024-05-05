// lib/features/community/widgets/post_widget.dart
import 'package:flutter/material.dart';
import 'package:byte_app/features/community/models/post_model.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byte_app/features/community/services/post_service.dart';
import 'package:byte_app/features/community/widgets/poll_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:share_plus/share_plus.dart';
import 'package:byte_app/features/community/services/dynamic_link_service.dart';
import 'package:byte_app/app_theme.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;
  final Function(String, String) onVote;
  final VoidCallback onComment;
  final VoidCallback onLike;
  final String profileImage;

  const PostWidget({
    Key? key,
    required this.post,
    required this.onVote,
    required this.onComment,
    required this.onLike,
    required this.profileImage,
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

  void onShareTap() async {
    try {
      Uri link = await DynamicLinkService().createDynamicLink(widget.post.id);
      Share.share('Check out this post: $link');
    } catch (e) {
      print('Could not generate the dynamic link: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    // Determine post type
    bool isImagePost = widget.post.imageUrl.isNotEmpty;
    bool isPollPost = widget.post.options.isNotEmpty;
    bool isTextPost = !isImagePost && !isPollPost;
    bool isNetworkImage = widget.profileImage.startsWith('http') ||
        widget.profileImage.startsWith('https');
    ImageProvider imageProvider;

    if (isNetworkImage) {
      imageProvider = NetworkImage(widget.profileImage);
    } else {
      imageProvider = AssetImage(widget.profileImage);
    }

    //Text style
    TextStyle baseTextStyle = appTheme.subtitle22;
    TextStyle boldTextStyle = baseTextStyle.copyWith(fontWeight: FontWeight.bold);
    // Use the bodyText1 style for timestamps
    TextStyle smallStyle = appTheme.bodyText11;

    return Card(
      color: appTheme.widgetBackground, // Use the cardBackground color from theme
      elevation: 0, // Set elevation to 0 to remove the shadow
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar( backgroundImage: imageProvider),
            title: Text(widget.post.topic, style: boldTextStyle),

            subtitle: Text(getFormattedTime(widget.post.timestamp), style: smallStyle),

            isThreeLine: isImagePost, // Extra space for the image description
          ),
          if (isTextPost) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.post.title, style: boldTextStyle),
                  SizedBox(height: 8.0),
                  Text(widget.post.content, style: baseTextStyle),
                ],
              ),
            ),
          ],
          if (isImagePost) ...[
            Image.network(
              widget.post.imageUrl,
              width: double.infinity,  // Make the image take up the full width of its container
              fit: BoxFit.cover,       // Ensure the image covers the widget area completely
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text('Could not load image', style: baseTextStyle));
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.post.description, style: baseTextStyle),
            ),
          ],
          if (isPollPost) ...[
            PollWidget(
              postId: widget.post.id,
              question: widget.post.question,
              votes: widget.post.votes,
              options: widget.post.options,
              onVote: widget.onVote,
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Like button and like count
                IconButton(
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                  color: isLiked ? appTheme.secondaryBackground : null,
                  onPressed: handleLike,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0), // Space after like count
                  child: Text('$likesCount', style: smallStyle),
                ),


                // Comment button and comment count
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: widget.onComment,
                  color: appTheme.secondaryBackground,
                ),
                Text('${widget.post.commentsCount}', style: smallStyle),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0), // Space after comment count
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  color: appTheme.secondaryBackground,
                  onPressed: onShareTap, // Invoke the share function when pressed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
