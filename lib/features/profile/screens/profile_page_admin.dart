import 'package:byte_app/features/alternatives/screens/user_favourites.dart';
import 'package:flutter/material.dart';
import 'explore_section_admin.dart'; // Assuming this is specific to admins
import 'saved_items_section.dart';
import 'package:byte_app/features/settings/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/features/profile/sections/UserProfileSection.dart';
import '../../../app_theme.dart';

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

    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileSection(onProfileLoaded: updateProfile),
              SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.greetings as String, // Updated to use localized string
                            textAlign: TextAlign.left,
                            style: AppTheme.of(context).title4.copyWith(
                                  color: AppTheme.of(context).alternate,
                                ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            localizations.greetings_two,
                            textAlign: TextAlign.left,
                            style: AppTheme.of(context).title3.copyWith(
                                  color: AppTheme.of(context).alternate,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, right: 30.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(profileImage),
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.of(context).primaryColor,
                            width: 1.0,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            profileImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ExploreSectionAdmin(), // Admin-specific explore section
              SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Text(
                  localizations
                      .yourFavourites, // Ensure this is defined in your localization files
                  textAlign: TextAlign.right,
                  style: AppTheme.of(context).title2.copyWith(
                        color: Color(0xFF181115),
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child:
                    FavoritesPreviewWidget(), // Include this to show favorites preview
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserFavouritesWidget()),
                  );
                },
                child: Center(
                  child: Text(
                    localizations.seeAllFavorites,
                    style: AppTheme.of(context).subtitle2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
