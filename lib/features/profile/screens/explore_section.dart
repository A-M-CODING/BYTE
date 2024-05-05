// lib/features/profile/screens/explore_section.dart
import 'package:flutter/material.dart';
import 'package:byte_app/features/profile/sections/ExploreSection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/features/community/screens/feed.dart';
import 'package:byte_app/features/community/screens/post.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:byte_app/features/alternatives/screens/get_prods_vids.dart';
import 'package:byte_app/features/chatbot/screens/chat.dart';
import 'package:byte_app/features/scan/screens/scan.dart';
import '../../../app_theme.dart';

class ExploreSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const double cardWidth = 110;
    const double cardHeight = 140;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              localizations.exploreTitle,
              style: AppTheme.of(context).title2.copyWith(
                    color: Color(0xFF181115),
                  ),
            ),
          ),
          Container(
            height: cardHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 6),
                ExploreCard(
                  title: localizations.scanButton,
                  iconData: Icons.camera_alt,
                  color: AppTheme.of(context).primaryColor,
                  width: cardWidth,
                  onTap: () {
                    // Navigate to the GetProdsVidsPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScanScreen()),
                    );
                  },
                ),
                SizedBox(width: 6),
                ExploreCard(
                  title: localizations.chatButton,
                  iconData: Icons.chat,
                  color: AppTheme.of(context).primaryColor,
                  width: cardWidth,
                  onTap: () {
                    // TODO: Navigate to Chat page
                    // Navigate to the ChatPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatbotScreen()),
                    );
                  },
                ),
                SizedBox(width: 6),
                ExploreCard(
                  title: localizations.communityButton,
                  iconData: Icons.group,
                  color: AppTheme.of(context).primaryColor,
                  width: cardWidth,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedScreen()),
                    );
                  },
                ),
                SizedBox(width: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
