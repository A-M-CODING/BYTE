// user_favourites.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../controllers/firestore_service.dart';
import 'package:byte_app/features/authentication/controllers/set_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserFavouritesWidget extends StatefulWidget {
  @override
  _UserFavouritesWidgetState createState() => _UserFavouritesWidgetState();
}

class _UserFavouritesWidgetState extends State<UserFavouritesWidget> {
  late FirestoreService firestoreService;

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService(); // Initialize FirestoreService
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userId = Provider.of<UserProvider>(context, listen: false).userId;
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 40) / 2; // Account for padding
    double itemHeight = 200; // Adjust as needed
    double childAspectRatio = itemWidth / itemHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text(
        AppLocalizations.of(context)!.yourFavorites),
        // ... other appBar properties
      ),
      body: userId == null
          ? Center(child: Text(AppLocalizations.of(context)!.pleaseLoginToSeeFavorites))
          : SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<List<AltProduct>>(
                    stream:
                        firestoreService.streamUserFavoriteProducts(userId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text(AppLocalizations.of(context)!.noFavoriteProductsFound));
                      }

                      List<AltProduct> favoriteProducts = snapshot.data!;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio:
                              screenWidth < 360 ? 0.55 : childAspectRatio,
                        ),
                        itemCount: favoriteProducts.length,
                        itemBuilder: (context, index) {
                          AltProduct product = favoriteProducts[index];
                          return Card(
                            color: AppTheme.of(context).widgetBackground,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppTheme.of(context).primaryColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              onTap: () => _launchURL(
                                  product.url), // Open the product URL
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1.8,
                                        child: Image.network(
                                          product.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                              softWrap: false,
                                            ),
                                            SizedBox(height: 4),
                                        Text(
                                          '${AppLocalizations.of(context)!.ratingLabel}:${product.rating}',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 2),
                                        Text(
                                          '${AppLocalizations.of(context)!.reviewsLabel}:${product.reviewCount}',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons
                                            .favorite, // Set this to always show the 'favorite' state
                                        color: AppTheme.of(context)
                                            .primaryColor, // The color should always be red since these are favorites
                                      ),
                                      onPressed: () async {
                                        // Call the method to remove the item from the database
                                        await firestoreService
                                            .removeUserFavorite(
                                                userId, product);

                                        // This setState call is to trigger a rebuild, it may not be needed if StreamBuilder updates the UI automatically.
                                        setState(() {
                                          // This might be optional, depending on whether StreamBuilder updates the list.
                                          favoriteProducts.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  StreamBuilder<List<YtVideo>>(
                    stream: firestoreService.streamUserFavoriteVideos(userId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text(
                            AppLocalizations.of(context)!.noFavoriteVideosFound));
                      }

                      List<YtVideo> favoriteVideos = snapshot.data!;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1,
                        ),
                        itemCount: favoriteVideos.length,
                        itemBuilder: (context, index) {
                          YtVideo video = favoriteVideos[index];
                          // We will use similar Card UI as in alt_foods_screen.dart for videos
                          return Card(
                            color: AppTheme.of(context).widgetBackground,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppTheme.of(context).primaryColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              onTap: () => _launchURL(video.videoLink),
                              child: Stack(
                                children: [
                                  InkWell(
                                    onTap: () => _launchURL(video.videoLink),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Image.network(
                                            video.thumbnailUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            video.title,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: IconButton(
                                      icon: Icon(
                                          Icons
                                              .favorite, // Set this to always show the 'favorite' state for videos
                                          color: AppTheme.of(context)
                                              .primaryColor // The color should always be red since these are favorites
                                          ),
                                      onPressed: () async {
                                        // Call the method to remove the video from the database
                                        await firestoreService
                                            .removeUserFavoriteVideo(
                                                userId, video);

                                        // This setState call is to trigger a rebuild, it may not be needed if StreamBuilder updates the UI automatically.
                                        setState(() {
                                          // This might be optional, depending on whether StreamBuilder updates the list.
                                          favoriteVideos.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
