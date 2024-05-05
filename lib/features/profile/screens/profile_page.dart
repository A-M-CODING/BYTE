
import 'package:byte_app/features/alternatives/screens/user_favourites.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'explore_section.dart';
import 'saved_items_section.dart';
import 'package:byte_app/features/settings/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/features/profile/sections/UserProfileSection.dart';
import '../../../app_theme.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  String profileImage = '';
  String username = '';
  void updateProfile(String image, String name) {
    setState(() {
      profileImage = image;
      username = formatUsername(name);
    });
  }
  String formatUsername(String email) {
    String namePart = email.split('@').first;
    String formattedName = '';
    for (int i = 0; i < namePart.length; i++) {
      if (namePart[i] == '.' || (namePart[i].isNotEmpty && '0123456789'.contains(namePart[i]))) {
        break;
      } else {
        formattedName += namePart[i];
      }
    }
    return formattedName;
  }
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
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
          backgroundColor: AppTheme.of(context).secondaryBackground,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileSection(onProfileLoaded: updateProfile),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: AppTheme.of(context).secondaryBackground,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(profileImage),
                            radius: 25,
                            backgroundColor: Colors.white,
                            foregroundImage: AssetImage(profileImage),
                          ),
                          SizedBox(height: 8),
                          Text(
                            localizations.greetings as String, // Updated to use localized string
                            style: AppTheme.of(context).title2.copyWith(
                                  color: Color(0xFF181115),
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              username,
                              style: AppTheme.of(context).title2.copyWith(
                                    color: Color(0xFF181115),
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              localizations.greetings_two, // Updated to use localized string
                              style: AppTheme.of(context).title2.copyWith(
                                    color: Color(0xFF181115),
                                    fontSize: 18,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/profile.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ExploreSection(),
              SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Text(
                  localizations.yourFavourites,
                  textAlign: TextAlign.right,
                  style: AppTheme.of(context).title2.copyWith(
                        color: Color(0xFF181115),
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: FavoritesPreviewWidget(),
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
