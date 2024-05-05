import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class UserProfileSection extends StatefulWidget {
  final Function(String, String) onProfileLoaded;

  const UserProfileSection({Key? key, required this.onProfileLoaded}) : super(key: key);

  @override
  _UserProfileSectionState createState() => _UserProfileSectionState();
}

class _UserProfileSectionState extends State<UserProfileSection> {
  String profileImage = '';
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? currentUser = auth.currentUser;
    final userId = currentUser?.uid ?? '';
    username = currentUser?.email?.split('@').first ?? 'User';

    profileImage = await UserProfileManager.getProfileImagePath(firestore, userId);

    setState(() {
      // Update the profile image and username
      this.profileImage = profileImage;
      this.username = username;
    });

    widget.onProfileLoaded(profileImage, username);
  }

  @override
  Widget build(BuildContext context) {
    // Since this widget doesn't render anything, we return an empty Container.
    return Container();
  }
}

class UserProfileManager {
  static const String adminImagePath = 'assets/images/fruits/watermelon.jpg'; // Path to your admin image
  static const List<String> predefinedImages = [
    'assets/images/fruits/apple.png',
    'assets/images/fruits/bananas.png',
    'assets/images/fruits/cherries.png',
    'assets/images/fruits/dragon-fruit.png',
    'assets/images/fruits/grapes.png',
    'assets/images/fruits/lemon.png',
    'assets/images/fruits/orange.png',
    'assets/images/fruits/pineapple.png',
    'assets/images/fruits/strawberry.png',
    'assets/images/fruits/strawberryb.png',
  ];

  static Future<String> getProfileImagePath(FirebaseFirestore firestore, String userId) async {
    // Check if the user is an admin
    bool isAdmin = await firestore.collection('adminuserids').doc(userId).get().then((doc) => doc.exists);
    if (isAdmin) {
      // Return the admin image path if the user is an admin
      return adminImagePath;
    } else {
      // For a regular user, get or assign a random predefined image
      return await _getOrAssignRegularUserProfileImage(firestore, userId);
    }
  }

  static Future<String> _getOrAssignRegularUserProfileImage(FirebaseFirestore firestore, String userId) async {
    final docRef = firestore.collection('profiles').doc(userId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists && docSnapshot.data()?['profileImage'] != null) {
      return docSnapshot.data()!['profileImage'];
    } else {
      int imageIndex = await _assignProfileImageIndex(firestore, userId);
      final imagePath = predefinedImages[imageIndex];
      await docRef.set({
        'profileImage': imagePath
      }, SetOptions(merge: true));
      return imagePath;
    }
  }

  static Future<int> _assignProfileImageIndex(FirebaseFirestore firestore, String userId) async {
    QuerySnapshot snapshot = await firestore.collection('profiles').get();

    var usedImages = snapshot.docs
        .where((doc) => doc.id != userId) // Exclude the current user's document
        .map((doc) => doc.data() as Map<String, dynamic>?) // Cast to a nullable Map
        .where((data) => data != null && data.containsKey('profileImage')) // Check for non-null and key existence
        .map((data) => data!['profileImage'] as String) // Extract the image path and cast to String
        .toList();

    List<int> freeIndexes = List.generate(predefinedImages.length, (index) => index);
    usedImages.forEach((usedImage) {
      int index = predefinedImages.indexOf(usedImage);
      if (index != -1) {
        freeIndexes.remove(index);
      }
    });

    if (freeIndexes.isEmpty) {
      return Random().nextInt(predefinedImages.length);
    }

    return freeIndexes[Random().nextInt(freeIndexes.length)];
  }
}
