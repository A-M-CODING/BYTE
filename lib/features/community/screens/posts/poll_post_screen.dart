// lib/features/community/screens/posts/poll_post_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byte_app/app_theme.dart';

class PollPostScreen extends StatefulWidget {
  @override
  _PollPostScreenState createState() => _PollPostScreenState();
}

class _PollPostScreenState extends State<PollPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _topicController = TextEditingController();
  List<String> options = ['', ''];

  @override
  void dispose() {
    _questionController.dispose();
    _categoryController.dispose();
    _topicController.dispose();
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

  void _submitPoll() async {
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

        // Remove empty options and filter out duplicates
        var uniqueOptions = options.where((option) => option.isNotEmpty).toSet().toList();
        // String username = currentUser.email!.split('@').first;

        // Save the poll to Firestore, now including the profileImageUrl
        FirebaseFirestore.instance.collection('posts').add({
          'topic': _topicController.text,
          'question': _questionController.text,
          'options': uniqueOptions,
          'userId': userId,
          'userProfileImage': profileImageUrl, // Add this line
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'poll',
          'likes': [],
          'commentsCount': 0,
          'categories': categories,
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
    final AppTheme theme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Poll"),
        elevation: 0,
        //APP BAR COLOR
        backgroundColor: theme.primaryBtnText,
        iconTheme: IconThemeData(
          color: theme.primaryText,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: 'Poll Question',
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
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ...options.asMap().entries.map((entry) => _optionField(entry.key)).toList(),

              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add Option',style: theme.typography.subtitle11.copyWith(color: theme.primaryBtnText)),
                onPressed: _addOption,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.secondaryBackground,
                  elevation: 0,
                  foregroundColor: theme.primaryBtnText,
                  padding: EdgeInsets.symmetric(vertical: 10.0),

                ),
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
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submitPoll,
                child: Text('Submit Poll', style: theme.typography.subtitle11.copyWith(color: theme.primaryBtnText)),
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
