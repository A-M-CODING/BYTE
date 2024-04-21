import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'explore_section.dart';
import 'saved_items_section.dart';
import 'package:byte_app/features/settings/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            tooltip: localizations.settingsButtonLabel, // Localized tooltip for the settings button
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
              SizedBox(height: 32),
              CircleAvatar(
                backgroundImage: AssetImage(profileImage),
                radius: 80,
              ),
              SizedBox(height: 16),
              Text(
                localizations.greetings(username), // Localized greeting
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 24),
              ExploreSection(), // Assumed to be a predefined widget
              SavedItemsSection(), // Assumed to be a predefined widget
            ],
          ),
        ),
      ),
    );
  }
}
