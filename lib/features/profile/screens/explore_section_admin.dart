// lib/features/profile/screens/explore_section_admin.dart
import 'package:flutter/material.dart';
import 'package:byte_app/features/profile/sections/ExploreSection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/features/community/screens/feed.dart';
import 'package:byte_app/features/community/screens/post.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ExploreSectionAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const double cardWidth = 150;
    const double cardHeight = 150;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            localizations.exploreTitle,
            style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: cardHeight,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(width: 20),
              ExploreCard(
                title: localizations.scanButton,
                iconData: Icons.camera_alt,
                color: Colors.green,
                width: cardWidth,
                onTap: () {
                  // TODO: Navigate to Scan page
                },
              ),
              SizedBox(width: 20),
              ExploreCard(
                title: localizations.chatButton,
                iconData: Icons.chat,
                color: Colors.blue,
                width: cardWidth,
                onTap: () {
                  // TODO: Navigate to Chat page
                },
              ),
              SizedBox(width: 20),
              ExploreCard(
                title: localizations.communityButton,
                iconData: Icons.group,
                color: Colors.pink,
                width: cardWidth,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedScreen()),
                  );
                },
              ),
              SizedBox(width: 20),
              ExploreCard(
                title: localizations.postButton,
                iconData: Icons.create,
                color: Colors.yellow,
                width: cardWidth,
                onTap: () {
                  PanelController _panelController = PanelController();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostScreen(panelController: _panelController)),
                  );
                },
              ),
              SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}
