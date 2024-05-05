// lib/features/community/screens/posts/text_post_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byte_app/app_theme.dart';

class TextPostScreen extends StatefulWidget {
  @override
  _TextPostScreenState createState() => _TextPostScreenState();
}

class _TextPostScreenState extends State<TextPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();
  final _topicController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  void _submitPost() async {
    if (_formKey.currentState!.validate()) {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        List<String> categories = _categoryController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

        // Fetch the profile image URL from the 'profiles' collection
        String profileImageUrl = await FirebaseFirestore.instance
            .collection('profiles')
            .doc(userId)
            .get()
            .then((doc) => doc.data()?['profileImage'] ?? 'assets/images/default_profile.png');

        // Save the post to Firestore, now including the profileImageUrl
        FirebaseFirestore.instance.collection('posts').add({
          'topic': _topicController.text,
          'title': _titleController.text,
          'content': _contentController.text,
          'userId': userId,
          'userProfileImage': profileImageUrl,
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'text',
          'likes': [],
          'commentsCount': 0,
          'categories': categories,
        }).then((result) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post created successfully!')));
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create post: $error')));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user logged in')));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Text Post"),
        elevation: 0,
        //APP BAR COLOR
        backgroundColor: theme.primaryBtnText,
        iconTheme: IconThemeData(
          color: theme.primaryText,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              TextFormField(
                controller: _topicController,
                decoration: InputDecoration(
                  labelText: 'Topic',
                  hintText: 'Enter Topic',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primaryText,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.secondaryBackground,
                    ),
                  ),
                  labelStyle: theme.subtitle22,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a topic';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter Title of Your content',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primaryText,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.secondaryBackground,
                    ),
                  ),
                  labelStyle: theme.subtitle22,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  hintText: 'Enter categories separated by commas',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primaryText,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.secondaryBackground,
                    ),
                  ),
                  labelStyle: theme.subtitle22,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter at least one category';
                  }
                  return null;
                },
              ),
              SizedBox(height:20),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primaryText,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.secondaryBackground,
                    ),
                  ),
                  labelStyle: theme.subtitle22,
                ),
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPost,
                child: Text('Submit Post', style: theme.typography.subtitle11.copyWith(color: theme.primaryBtnText)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.secondaryBackground,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}