import 'package:flutter/material.dart';
import 'explore_section_admin.dart'; // Assuming this is specific to admins
import 'saved_items_section.dart';
import 'package:byte_app/features/settings/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/features/profile/sections/UserProfileSection.dart';

class ProfilePageAdmin extends StatefulWidget {
  @override
  _ProfilePageAdminState createState() => _ProfilePageAdminState();
}

class _ProfilePageAdminState extends State<ProfilePageAdmin> {
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
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            tooltip: localizations.settingsButtonLabel,
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
              UserProfileSection(onProfileLoaded: updateProfile),
              SizedBox(height: 32),
              CircleAvatar(
                backgroundImage: AssetImage(profileImage),
                radius: 80,
              ),
              SizedBox(height: 16),
              Text(
                localizations.greetings(username),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 24),
              ExploreSectionAdmin(), // Admin-specific explore section
              SavedItemsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
