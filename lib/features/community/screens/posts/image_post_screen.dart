// lib/features/community/screens/posts/image_post_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImagePostScreen extends StatefulWidget {
  @override
  _ImagePostScreenState createState() => _ImagePostScreenState();
}

class _ImagePostScreenState extends State<ImagePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descriptionController.dispose();
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
<<<<<<< HEAD
        // Upload image to Firebase Storage using the method from Code A
=======
        String userId = currentUser.uid;

        // Fetch the profile image URL from the 'profiles' collection
        String profileImageUrl = await FirebaseFirestore.instance
            .collection('profiles')
            .doc(userId)
            .get()
            .then((doc) => doc.data()?['profileImage'] ?? 'assets/images/default_profile.png');

        // Upload image to Firebase Storage
>>>>>>> fe279d9 (Updated community features)
        final ref = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}_${_image!.name}');
        try {
          await ref.putFile(File(_image!.path));
          final url = await ref.getDownloadURL();

          String username = currentUser.email!.split('@').first;

<<<<<<< HEAD
          // Save post details in Firestore
=======
          // Save post details in Firestore, now including the profileImageUrl
>>>>>>> fe279d9 (Updated community features)
          FirebaseFirestore.instance.collection('posts').add({
            'description': _descriptionController.text,
            'imageUrl': url,
            'userId': username,
<<<<<<< HEAD
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'image',
            'likes': [],  // Initialize likes count
            'comments': []  // Initialize comments array
=======
            'userProfileImage': profileImageUrl, // Add this line
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'image',
            'likes': [],
            'commentsCount': 0,
>>>>>>> fe279d9 (Updated community features)
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Image Post"),
      ),
      body: Padding(
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
                child: Text('Pick Image'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadAndSavePost,
                child: Text('Submit Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
