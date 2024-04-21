import 'package:flutter/material.dart';
import 'package:byte_app/features/profile/sections/ExploreSection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExploreSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // Assuming you have a padding or margin around the card, include that in the calculation
    const double cardWidth = 150; // Set a larger width
    const double cardHeight = 150; // Set a larger height if needed

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
          height: cardHeight, // Update the height accordingly
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(width: 20), // Optional: add a starting spacing
              ExploreCard(
                title: localizations.scanButton,
                iconData: Icons.camera_alt,
                color: Colors.green,
                width: cardWidth, // Pass the width to the ExploreCard
                onTap: () {
                  // TODO: Navigate to Scan page
                },
              ),
              SizedBox(width: 20), // Spacing between cards
              ExploreCard(
                title: localizations.chatButton,
                iconData: Icons.chat,
                color: Colors.blue,
                width: cardWidth, // Pass the width to the ExploreCard
                onTap: () {
                  // TODO: Navigate to Chat page
                },
              ),
              SizedBox(width: 20), // Spacing between cards
              ExploreCard(
                title: localizations.communityButton,
                iconData: Icons.group,
                color: Colors.pink,
                width: cardWidth, // Pass the width to the ExploreCard
                onTap: () {
                  // TODO: Navigate to Community page
                },
              ),
              SizedBox(width: 20), // Optional: add an ending spacing
              // Add more cards as needed
            ],
          ),
        ),
      ],
    );
  }
}
