import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
=======
>>>>>>> fe279d9 (Updated community features)
import 'explore_section.dart';
import 'saved_items_section.dart';
import 'package:byte_app/features/settings/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
<<<<<<< HEAD
=======
import 'package:byte_app/features/profile/sections/UserProfileSection.dart'; // Import the new user profile section
>>>>>>> fe279d9 (Updated community features)

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
<<<<<<< HEAD
  final List<String> predefinedImages = [
    'assets/images/avatars/men.jpg',
    'assets/images/avatars/men2.jpg',
    'assets/images/avatars/women.jpg',
    'assets/images/avatars/women2.jpg',
    // Add more predefined images if needed
  ];

  String profileImage = '';
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Try to get the saved index from prefs; if it's not there, generate a new one
    int savedIndex = prefs.getInt('profileImageIndex_$userId') ?? Random().nextInt(predefinedImages.length);

    // Save the index if it's newly generated to ensure it remains consistent on subsequent app launches
    prefs.setInt('profileImageIndex_$userId', savedIndex);

    // Now we can safely use savedIndex as it's guaranteed to be non-null
    setState(() {
      username = FirebaseAuth.instance.currentUser?.email?.split('@').first ?? 'User';
      profileImage = predefinedImages[savedIndex]; // No error as savedIndex is an int
    });
  }
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Assuming this is properly set up
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.profileTitle), // Localized title for the AppBar
=======
  String profileImage = '';
  String username = '';

  void updateProfile(String image, String name) {
    setState(() {
      profileImage = image;
      username = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.profileTitle),
>>>>>>> fe279d9 (Updated community features)
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
<<<<<<< HEAD
            tooltip: localizations.settingsButtonLabel, // Localized tooltip for the settings button
=======
            tooltip: localizations.settingsButtonLabel,
>>>>>>> fe279d9 (Updated community features)
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
<<<<<<< HEAD
=======
              UserProfileSection(onProfileLoaded: updateProfile),
>>>>>>> fe279d9 (Updated community features)
              SizedBox(height: 32),
              CircleAvatar(
                backgroundImage: AssetImage(profileImage),
                radius: 80,
              ),
              SizedBox(height: 16),
              Text(
<<<<<<< HEAD
                localizations.greetings(username), // Localized greeting
=======
                localizations.greetings(username),
>>>>>>> fe279d9 (Updated community features)
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 24),
<<<<<<< HEAD
              ExploreSection(), // Assumed to be a predefined widget
              SavedItemsSection(), // Assumed to be a predefined widget
=======
              ExploreSection(),
              SavedItemsSection(),
>>>>>>> fe279d9 (Updated community features)
            ],
          ),
        ),
      ),
    );
  }
}
