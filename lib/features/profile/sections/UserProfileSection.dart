import 'package:flutter/material.dart';

class SavedItemCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isLiked;

  const SavedItemCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    this.isLiked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6, // 60% of screen width
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity, // Full width of the card
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.favorite,
              color: isLiked ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
