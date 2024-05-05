import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../models/product.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:byte_app/features/authentication/controllers/set_provider.dart';
import 'user_favourites.dart';
import '../../../app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AltProductListingWidget extends StatefulWidget {
  final List<AltProduct> altProducts;
  final List<YtVideo> ytVideos;
  final String productsErrorMessage;
  final String videosErrorMessage;

  const AltProductListingWidget({
    Key? key,
    required this.altProducts,
    required this.ytVideos,
    required this.productsErrorMessage,
    required this.videosErrorMessage,
  }) : super(key: key);

  @override
  _AltProductListingWidgetState createState() =>
      _AltProductListingWidgetState();
}

// Declare a GlobalKey for the Videos section title.
GlobalKey videosTitleKey = GlobalKey();

ScrollController productScrollController = ScrollController();
ScrollController videoScrollController = ScrollController();

class _AltProductListingWidgetState extends State<AltProductListingWidget> {
  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSearchStarted = false;
  List<AltProduct> searchedAltProducts = [];

  late FirestoreService firestoreService; // Use 'late' for lazy initialization

  @override
  void initState() {
    super.initState();
    firestoreService =
        FirestoreService(); // This will initialize the field before it's used.
    textController = TextEditingController();
  }

// Helper method to launch URLs.
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  void dispose() {
    productScrollController.dispose();
    videoScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? userId = Provider.of<UserProvider>(context, listen: false).userId;
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 40) / 2;
    double itemHeight = 200;
    double childAspectRatio = itemWidth / itemHeight;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.alternativeFoodsTitle,
          style: AppTheme.of(context).title3.copyWith(
                fontSize: 18,
                color: AppTheme.of(context).alternate,
              ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserFavouritesWidget()),
              );
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        controller: productScrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.of(context).widgetBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: AppTheme.of(context).primaryColor,
                        size: 24,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: textController,
                          obscureText: false,
                          onChanged: (value) {
                            isSearchStarted = value.isNotEmpty;
                            searchedAltProducts = widget.altProducts
                                .where((item) => item.name
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.searchItemPlaceholder,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 4),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppTheme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Displaying Error Messages
            if (widget.altProducts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(widget.productsErrorMessage,
                    style: TextStyle(fontSize: 16, color: Colors.red)),
              ),
            if (widget.ytVideos.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(widget.videosErrorMessage,
                    style: TextStyle(fontSize: 16, color: Colors.red)),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => productScrollController.animateTo(
                    productScrollController.position.minScrollExtent,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.productsLabel,
                    style: AppTheme.of(context).title3.copyWith(
                          color: AppTheme.of(context).widgetBackground,
                          fontWeight: FontWeight.w200,
                          fontSize: 14,
                        ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.of(context).primaryColor,
                    foregroundColor: AppTheme.of(context).widgetBackground,
                    side: BorderSide(
                        color: AppTheme.of(context).widgetBackground),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Check if the current context of videosTitleKey is not null
                    if (videosTitleKey.currentContext != null) {
                      // Use the current context to find the render box of the videos title.
                      final RenderBox videosTitleBox =
                          videosTitleKey.currentContext!.findRenderObject()
                              as RenderBox;
                      final Offset videosTitlePosition =
                          videosTitleBox.localToGlobal(Offset.zero);

                      // Scroll to the Y position of the videos title.
                      productScrollController.animateTo(
                        videosTitlePosition.dy,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.videosLabel,
                    style: AppTheme.of(context).title3.copyWith(
                          color: AppTheme.of(context).widgetBackground,
                          fontWeight: FontWeight.w200,
                          fontSize: 14,
                        ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.of(context).primaryColor,
                    foregroundColor: AppTheme.of(context).widgetBackground,
                    side: BorderSide(
                        color: AppTheme.of(context).widgetBackground),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.productsLabel,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

// Conditional Grid Display for Products
            if (widget.altProducts.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: screenWidth < 360 ? 0.55 : childAspectRatio,
                ),
                itemCount: isSearchStarted
                    ? searchedAltProducts.length
                    : widget.altProducts.length,
                itemBuilder: (context, index) {
                  var altProduct = isSearchStarted
                      ? searchedAltProducts[index]
                      : widget.altProducts[index];
                  if (altProduct.name == "No Title Found" ||
                      altProduct.image.isEmpty) {
                    return Container(); // Skip rendering this product entirely
                  }
                  // Existing card rendering code
                  return GestureDetector(
                    onTap: () => _launchURL(altProduct.url),
                    child: Card(
                      color: AppTheme.of(context).widgetBackground,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppTheme.of(context).primaryColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.8,
                                child: Image.network(
                                  altProduct.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      altProduct.name,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth < 360 ? 10 : 12,
                                      ),
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${AppLocalizations.of(context)!.ratingLabel}: ${altProduct.reviewCount}',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: screenWidth < 360 ? 8 : 10,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      '${AppLocalizations.of(context)!.reviewsLabel}: ${altProduct.reviewCount}',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: screenWidth < 360 ? 8 : 10,
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
                                  altProduct.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 24,
                                  color: altProduct.isFavorite
                                      ? AppTheme.of(context).primaryColor
                                      : AppTheme.of(context)
                                          .primaryColor // Add this line
                                  ),
                              onPressed: () async {
                                var isFavorite = !altProduct.isFavorite;
                                setState(() {
                                  altProduct.isFavorite = isFavorite;
                                });
                                // When adding or removing a favorite, get the userId from the provider
                                String? userId = Provider.of<UserProvider>(
                                        context,
                                        listen: false)
                                    .userId;

                                // Use it to add or remove the favorite
                                if (isFavorite) {
                                  await firestoreService.addUserFavorite(
                                      userId, altProduct);
                                } else {
                                  await firestoreService.removeUserFavorite(
                                      userId, altProduct);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.videosLabel,
                key: videosTitleKey, // Assign the GlobalKey here
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

// Conditional Grid Display for Videos
            if (widget.ytVideos.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjust based on your design
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: widget.ytVideos.length,
                itemBuilder: (context, index) {
                  final YtVideo video = widget.ytVideos[index];
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _launchURL(video.videoLink),
                        child: Card(
                          color: AppTheme.of(context).widgetBackground,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppTheme.of(context).primaryColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  video
                                      .thumbnailUrl, // now it should be defined
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  video.title, // Corrected to video.title
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                            video.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 24,
                            color: video.isFavorite
                                ? AppTheme.of(context).primaryColor
                                : AppTheme.of(context).primaryColor),
                        onPressed: () async {
                          // Toggle the favorite status
                          setState(() {
                            video.isFavorite = !video.isFavorite;
                          });

                          // When adding or removing a favorite, get the userId from the provider
                          String? userId =
                              Provider.of<UserProvider>(context, listen: false)
                                  .userId;

                          // Use it to add or remove the favorite
                          if (video.isFavorite) {
                            await firestoreService.addUserFavoriteVideo(
                                userId, video);
                          } else {
                            await firestoreService.removeUserFavoriteVideo(
                                userId, video);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
