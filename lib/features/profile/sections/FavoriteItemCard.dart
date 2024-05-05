import 'package:flutter/material.dart';
import 'package:byte_app/features/alternatives/models/product.dart';

class FavoriteItemCard extends StatelessWidget {
  final dynamic item; // Can be AltProduct or YtVideo
  final VoidCallback onTap;

  const FavoriteItemCard({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFFEDEB),
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFFC7562), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 1.8,
                  child: item is AltProduct
                      ? Image.network(
                          item.image,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset('assets/images/default.png',
                                fit: BoxFit.cover);
                          },
                        )
                      : Image.network(
                          item.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset('assets/images/default.png',
                                fit: BoxFit.cover);
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item is AltProduct ? item.name : item.title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      const SizedBox(height: 4),
                      if (item is AltProduct) ...[
                        Text(
                          'Rating: ${item.rating}',
                          style: const TextStyle(fontFamily: 'Poppins'),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Reviews: ${item.reviewCount}',
                          style: const TextStyle(fontFamily: 'Poppins'),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
