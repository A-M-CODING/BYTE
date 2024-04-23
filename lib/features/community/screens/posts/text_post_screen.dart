// lib/features/community/screens/posts/text_post_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TextPostScreen extends StatefulWidget {
  @override
  _TextPostScreenState createState() => _TextPostScreenState();
}

class _TextPostScreenState extends State<TextPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Get the user ID of the currently logged-in user
        String username = currentUser.email!.split('@').first;

        // Save the post to Firestore
        FirebaseFirestore.instance.collection('posts').add({
          'title': _titleController.text,
          'content': _contentController.text,
          'userId': username, // Save user ID along with other post data
          'timestamp': FieldValue.serverTimestamp(), // Automatically set the server timestamp
          'type': 'text', // Specify the type of post
          'likes': [],  // Initialize likes count
          'comments': []  // Initialize comments array
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Text Post"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
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
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
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
                child: Text('Submit Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
