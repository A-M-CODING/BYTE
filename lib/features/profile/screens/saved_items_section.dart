import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:byte_app/features/alternatives/models/product.dart';
import 'package:byte_app/features/alternatives/controllers/firestore_service.dart';
import 'package:byte_app/features/authentication/controllers/set_provider.dart';
import 'package:byte_app/features/profile/sections/FavoriteItemCard.dart';
import 'package:byte_app/features/alternatives/screens/user_favourites.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesPreviewWidget extends StatelessWidget {
  FavoritesPreviewWidget({Key? key}) : super(key: key);

  // Helper method to launch URLs.
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    final FirestoreService firestoreService = FirestoreService();

    if (userId == null) {
      return Center(child: Text('Please log in to see favorites'));
    }

    // Combine the streams of products and videos
    final combinedStream =
        Rx.combineLatest2<List<AltProduct>, List<YtVideo>, List<dynamic>>(
      firestoreService
          .streamUserFavoriteProducts(userId)
          .map((products) => products.take(3).toList()),
      firestoreService
          .streamUserFavoriteVideos(userId)
          .map((videos) => videos.take(3).toList()),
      (List<AltProduct> products, List<YtVideo> videos) =>
          products.cast<dynamic>() + videos.cast<dynamic>(),
    );
    return StreamBuilder<List<dynamic>>(
      stream: combinedStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No favorite items found'));
        }

        // Here we create a unified list containing both AltProduct and YtVideo
        final items = snapshot.data!;

        // Include an extra count for the arrow at the end
        int itemCount = items.length + 1;

        return Container(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            separatorBuilder: (context, index) => SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserFavouritesWidget(),
                    ));
                  },
                );
              }

              return Container(
                width: 200,
                child: FavoriteItemCard(
                  item: items[index],
                  onTap: () {
                    if (items[index] is AltProduct) {
                      _launchURL(items[index].url);
                    } else if (items[index] is YtVideo) {
                      _launchURL(items[index].videoLink);
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
