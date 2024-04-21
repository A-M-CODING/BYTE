import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../models/product.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:byte_app/features/authentication/controllers/set_provider.dart';

class AltProductListingWidget extends StatefulWidget {
  final List<AltProduct> altProducts;
  final List<YtVideo> ytVideos; // Ensure this field is present

  const AltProductListingWidget({
    Key? key,
    required this.altProducts,
    required this.ytVideos, // Ensure this argument is required
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
    double itemWidth = (screenWidth - 40) / 2; // Account for padding
    double itemHeight = 200; // Adjust as needed
    double childAspectRatio = itemWidth / itemHeight;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Add this line
        title: Text(
          'Alternative Foods For You',
          style: AppTheme.of(context).title1.override(
                fontFamily: 'Poppins',
              ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.food_bank_outlined),
            onPressed: () {
              // Navigate to the get_prods_vids.dart page
              Navigator.of(context).pushReplacementNamed('/prodsVids');
            },
          ),
          IconButton(
            icon:
                Icon(Icons.favorite_border), // Add this line for the heart icon
            onPressed: () {
              // Your functionality for the heart icon goes here
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
                  color: AppTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.of(context).primaryBackground,
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
                        color: Color(0xFF95A1AC),
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
                            labelText: 'Search product here...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 4),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF95A1AC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                  child: Text('Products'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.grey,
                    shadowColor: Colors.transparent,
                    side: BorderSide(color: Colors.grey),
                    padding: EdgeInsets.symmetric(horizontal: 64, vertical: 16),
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
                  child: Text('Videos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.grey,
                    shadowColor: Colors.transparent,
                    side: BorderSide(color: Colors.grey),
                    padding: EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Products',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
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
                return GestureDetector(
                  onTap: () => _launchURL(altProduct.url),
                  child: Card(
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
                                    'Rating: ${altProduct.rating}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: screenWidth < 360 ? 8 : 10,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Reviews: ${altProduct.reviewCount}',
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
                            icon: Icon(Icons.favorite_border, size: 24),
                            onPressed: () async {
                              var isFavorite = !altProduct.isFavorite;
                              setState(() {
                                altProduct.isFavorite = isFavorite;
                              });
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
                'Videos',
                key: videosTitleKey, // Assign the GlobalKey here
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // or however many cards you want per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1, // Adjust based on your design
              ),
              itemCount: widget.ytVideos.length,
              itemBuilder: (context, index) {
                final YtVideo video = widget.ytVideos[index];
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => _launchURL(
                          video.videoLink), // now it should be defined
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                video.thumbnailUrl, // now it should be defined
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
                      icon: Icon(Icons.favorite_border, size: 24), // Heart icon
                      onPressed: () {
                        // Placeholder for your functionality
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
