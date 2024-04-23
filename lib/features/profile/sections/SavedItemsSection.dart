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
      width: MediaQuery.of(context).size.width * 0.6,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Card(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title, style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}