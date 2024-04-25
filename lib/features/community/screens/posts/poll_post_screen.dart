// lib/features/community/screens/posts/poll_post_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PollPostScreen extends StatefulWidget {
  @override
  _PollPostScreenState createState() => _PollPostScreenState();
}

class _PollPostScreenState extends State<PollPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  List<String> options = ['', ''];

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _addOption() {
    setState(() {
      options.add('');
    });
  }

  void _removeOption(int index) {
    setState(() {
      options.removeAt(index);
    });
  }

  Widget _optionField(int index) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Option ${index + 1}',
        suffixIcon: index >= 2 ? IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () => _removeOption(index),
        ) : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an option';
        }
        return null;
      },
      onChanged: (value) {
        options[index] = value;
      },
    );
  }

<<<<<<< HEAD
  void _submitPoll() {
    if (_formKey.currentState!.validate()) {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
=======
  void _submitPoll() async {
    if (_formKey.currentState!.validate()) {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;

        // Fetch the profile image URL from the 'profiles' collection
        String profileImageUrl = await FirebaseFirestore.instance
            .collection('profiles')
            .doc(userId)
            .get()
            .then((doc) => doc.data()?['profileImage'] ?? 'assets/images/default_profile.png');

>>>>>>> fe279d9 (Updated community features)
        // Remove empty options and filter out duplicates
        var uniqueOptions = options.where((option) => option.isNotEmpty).toSet().toList();
        String username = currentUser.email!.split('@').first;

<<<<<<< HEAD
        FirebaseFirestore.instance.collection('posts').add({
          'question': _questionController.text,
          'options': uniqueOptions,
          'userId':username,
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'poll',
          'likes': [],  // Initialize likes count
          'comments': []  // Initialize comments array
=======
        // Save the poll to Firestore, now including the profileImageUrl
        FirebaseFirestore.instance.collection('posts').add({
          'question': _questionController.text,
          'options': uniqueOptions,
          'userId': username,
          'userProfileImage': profileImageUrl, // Add this line
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'poll',
          'likes': [],
          'commentsCount': 0,
>>>>>>> fe279d9 (Updated community features)
        }).then((result) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Poll created successfully!')));
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create poll: $error')));
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
        title: Text("Create Poll"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: 'Poll Question',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ...options.asMap().entries.map((entry) => _optionField(entry.key)).toList(),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add Option'),
                onPressed: _addOption,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPoll,
                child: Text('Submit Poll'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
