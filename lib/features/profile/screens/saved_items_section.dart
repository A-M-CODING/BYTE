import 'package:flutter/material.dart';
import 'package:byte_app/features/profile/sections/SavedItemsSection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Ensure this import points to the location of SavedItemCard class

class SavedItemsSection extends StatelessWidget {
  // This data would typically come from your database or state management solution.
  // Here, it's hardcoded for demonstration purposes.
  final List<Map<String, dynamic>> items = [
    {'title': 'Item 1', 'image': 'https://via.placeholder.com/150', 'isLiked': true},
    {'title': 'Item 2', 'image': 'https://via.placeholder.com/150', 'isLiked': false},
    // Add more items as needed...
  ];

  SavedItemsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            localizations.savedItemsTitle, // Localized title
            style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 240, // Height adjusted to accommodate the padding and heading
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return SavedItemCard(
                title: items[index]['title'],
                imageUrl: items[index]['image'],
                isLiked: items[index]['isLiked'],
              );
            },
          ),
        ),
      ],
    );
  }
}