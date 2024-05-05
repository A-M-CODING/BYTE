// lib/features/community/screens/posts/image_post_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byte_app/app_theme.dart';

class ImagePostScreen extends StatefulWidget {
  @override
  _ImagePostScreenState createState() => _ImagePostScreenState();
}

class _ImagePostScreenState extends State<ImagePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController(); // New controller for category
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final _topicController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _categoryController.dispose();
    _topicController.dispose();// Dispose new controller
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> _uploadAndSavePost() async {
    if (_formKey.currentState!.validate() && _image != null) {
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

        // Upload image to Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}_${_image!.name}');
        try {
          await ref.putFile(File(_image!.path));
          final url = await ref.getDownloadURL();

          // String username = currentUser.email!.split('@').first;

          // Save post details in Firestore, now including the profileImageUrl and categories
          FirebaseFirestore.instance.collection('posts').add({
            'topic': _topicController.text,
            'description': _descriptionController.text,
            'imageUrl': url,
            'userId': userId,
            'userProfileImage': profileImageUrl,
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'image',
            'likes': [],
            'commentsCount': 0,
            'categories': categories, // Added categories field
          }).then((result) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image post created successfully!')));
            Navigator.pop(context);
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create image post: $error')));
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user logged in')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please pick an image and fill in all fields')));
    }
  }


  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Image Post"),
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
              if (_image != null)
                Image.file(File(_image!.path)),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image',style: theme.typography.subtitle11.copyWith(color: theme.primaryBtnText)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.secondaryBackground,
                  elevation: 0,
                  foregroundColor: theme.primaryBtnText,
                  padding: EdgeInsets.symmetric(vertical: 10.0),

                ),
              ),
              SizedBox(height: 20),

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
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
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
                    return 'Please enter a description';
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
                    return 'Please enter at least one category ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadAndSavePost,
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