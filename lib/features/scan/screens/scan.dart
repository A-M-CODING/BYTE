import 'dart:convert';
import 'dart:io';
import 'package:byte_app/features/alternatives/screens/get_prods_vids.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:scanning_effect/scanning_effect.dart';
import 'package:uuid/uuid.dart';
import '../../alternatives/screens/alt_foods_screen.dart';
import '../../alternatives/models/product.dart';
import '../../../app_theme.dart';

Future<List<YtVideo>> fetchVideos(String searchQuery) async {
  final videoResponse = await http.post(
    Uri.parse(
        'https://us-central1-byte-e6f0c.cloudfunctions.net/get-youtube-links'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'search_query': searchQuery}),
  );

  if (videoResponse.statusCode == 200) {
    final List<dynamic> videosInfoJson = jsonDecode(videoResponse.body);
    return videosInfoJson
        .map((videoJson) => YtVideo.fromJson(videoJson))
        .toList();
  } else {
    throw Exception('Failed to load videos');
  }
}

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  bool _isUrdu(String? text) {
    // A simple check based on typical characters in Urdu; adjust as necessary
    return text?.contains(RegExp(r'[\u0600-\u06FF]')) ?? false;
  }

  bool isEnglish(String text) {
    // Returns true if the text contains only English letters (and possibly some punctuation and numbers)
    return RegExp(r'^[a-zA-Z0-9 .,;?!@#$%^&*`]+$').hasMatch(text);
  }

  String formatResponse(String? text) {
    if (text == null) return "No response";
    if (isEnglish(text)) return text;
    return text.replaceAll(
        '. ', '.\n'); // Replace periods with new lines for non-English
  }

  XFile? _pickedImage;
  bool _isLoading = false;
  String? _responseText;
  List<String> _documentUrls = [];
  late AnimationController _animationController;
  String? _summaryText; // Add this line near your other state variables
  Map<String, dynamic>? userData;
  String? _imageInfo; // State variable to store image info from backend

  void showLoadingDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must not dismiss the dialog manually
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text(text, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    fetchUserData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Check if the widget is still in the tree
        pickImage(ImageSource.camera);
      }
    });
  }

// Null-safe user info message generation
  String generateUserInfoMessage(Map<String, dynamic> userData) {
    List<String> infoParts = [];

    // Demographics
    if (userData['age'] != null && userData['gender'] != null) {
      infoParts.add(
          'is a ${userData['age']} year old ${userData['gender'].toLowerCase()}');
    }

    // Location
    if (userData['location'] != null && userData['location'].isNotEmpty) {
      infoParts.add('based in ${userData['location']}');
    }

    // Weight and Height
    if (userData['weight'] != null && userData['height'] != null) {
      infoParts.add(
          'and weighs ${userData['weight']}kg and is ${userData['height']}cm tall');
    }
    // Allergies
    if (userData['allergies'] != null && userData['allergies'].isNotEmpty) {
      infoParts.add('User is allergic to ${userData['allergies'].join(", ")}.');
    }

    // Diseases
    if (userData['diseases'] != null && userData['diseases'].isNotEmpty) {
      infoParts.add('User has ${userData['diseases'].join(" and ")}');
    }

    // Dietary Preferences
    if (userData['dietaryPreferences'] != null &&
        userData['dietaryPreferences'].isNotEmpty) {
      infoParts.add(
          'They follow a ${userData['dietaryPreferences'].join(" and ")} diet');
    }

    // Religious Dietary Restrictions
    if (userData['religiousDietaryRestrictions'] != null &&
        userData['religiousDietaryRestrictions'].isNotEmpty) {
      infoParts.add(
          'User also observes ${userData['religiousDietaryRestrictions'].join(" and ")} dietary restrictions');
    }

    // Activity Level
    if (userData['activityLevel'] != null &&
        userData['activityLevel'].isNotEmpty) {
      infoParts.add(
          'They have a ${userData['activityLevel'].toLowerCase()} activity level.');
    }

    // Health Goals
    if (userData['healthGoals'] != null && userData['healthGoals'].isNotEmpty) {
      infoParts.add('They aim to ${userData['healthGoals'].join(" and ")}');
    }

    // App Purpose
    if (userData['appPurpose'] != null && userData['appPurpose'].isNotEmpty) {
      infoParts
          .add('They use the app for ${userData['appPurpose'].join(" and ")}');
    }

    // Additional Info
    if (userData['additionalInfo'] != null &&
        userData['additionalInfo'].isNotEmpty) {
      infoParts.add('User has also added that: ${userData['additionalInfo']}');
    }

    // Combine all parts into a full sentence
    return 'User ' + infoParts.join(", ") + '.';
  }

// Fetch user data and store it
  Future<void> fetchUserData() async {
    // Assuming 'user' is available
    DocumentSnapshot userDocument = await FirebaseFirestore.instance
        .collection('user_health_data')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (userDocument.exists) {
      setState(() {
        userData = userDocument.data() as Map<String, dynamic>?;
        if (userData != null) {
          userData!['userInfoMessage'] = generateUserInfoMessage(userData!);
        }
      });
    }
  }

  Future<void> getAlternatives(String imageInfo, String userInfo) async {
    setState(() {
      _isLoading = true;
    });

    showLoadingDialog(context, AppLocalizations.of(context)!.fetching_alt);

    // Use widget.imageInfo and widget.userInfo directly
    final String nutritionLabel = imageInfo;
    final String userInfo = userData!['userInfoMessage'];
    List<AltProduct> productsInfo = [];
    List<YtVideo> videosInfo = [];
    String productsErrorMessage = '';
    String videosErrorMessage = '';

    try {
      // Call the generate-search-query Cloud Function
      final generateSearchQueryResponse = await http.post(
        Uri.parse(
            'https://us-central1-byte-e6f0c.cloudfunctions.net/generate-search-query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nutr_label': nutritionLabel, 'user_info': userInfo}),
      );

      if (generateSearchQueryResponse.statusCode == 200) {
        // Assuming the response is plain text, not JSON.
        final String generatedSearchQuery = generateSearchQueryResponse.body;
        print('Generated Search Query: $generatedSearchQuery');

        // Prepare Future calls for fetching products and videos
        final fetchProductsFuture = http.post(
          Uri.parse(
              'https://us-central1-byte-e6f0c.cloudfunctions.net/get-alt-prods-links'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'search_query': generatedSearchQuery}),
        );

        final fetchVideosFuture = fetchVideos(generatedSearchQuery);

        // Execute both Future calls in parallel
        final results = await Future.wait([
          fetchProductsFuture,
          fetchVideosFuture.catchError((e) {
            videosErrorMessage = 'Sorry, no relevant videos found';
            return []; // Return empty list on error
          })
        ]);

        // Handle products response
        final fetchProductsResponse = results[0] as http.Response;
        if (fetchProductsResponse.statusCode == 200) {
          final List<dynamic> productsInfoJson =
              jsonDecode(fetchProductsResponse.body);
          productsInfo = productsInfoJson
              .map((productJson) => AltProduct.fromJson(productJson))
              .where((product) =>
                  product.name != null &&
                  product.name.isNotEmpty &&
                  product.name !=
                      "No Title Found" && // Exclude products with "No Title Found"
                  product.image != null &&
                  product.image.isNotEmpty)
              .toList();

          if (productsInfo.isEmpty) {
            productsErrorMessage = 'Sorry, no alternate products found';
          }
        } else {
          productsErrorMessage = 'Sorry, no alternate products found';
        }
        // Handle videos response
        videosInfo = results[1] as List<YtVideo>;
        if (videosInfo.isEmpty && videosErrorMessage.isEmpty) {
          videosErrorMessage = 'Sorry, no relevant videos found';
        }
      } else {
        productsErrorMessage = 'Sorry, no alternate products found';
        videosErrorMessage = 'Sorry, no relevant videos found';
        print(
            'Failed to generate search query: ${generateSearchQueryResponse.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
      productsErrorMessage = 'Sorry, no alternate products found';
      videosErrorMessage = 'Sorry, no relevant videos found';
    } finally {
      hideLoadingDialog(context);
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading when done or on error
        });
      }
    }

    // Navigate to AltFoodsScreen with the fetched products and videos
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AltProductListingWidget(
          altProducts: productsInfo,
          ytVideos: videosInfo,
          productsErrorMessage: productsErrorMessage,
          videosErrorMessage: videosErrorMessage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context); // Get your theme data

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            appTheme.secondaryBackground, // Use the primary bittersweet color
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: _isLoading
          ? buildLoadingScreen()
          : buildResultScreen(
              appTheme), // Check _isLoading to decide the widget
    );
  }

  Widget buildLoadingScreen() {
    return _pickedImage == null
        ? Center(child: CircularProgressIndicator())
        : ScanningEffect(
            // Use the ScanningEffect widget
            scanningColor: Color(0xFFFC7562),
            borderLineColor: Colors.white,
            duration: Duration(seconds: 2),
            child: Image.file(File(_pickedImage!.path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity),
          );
  }

  Widget buildSummarySection(AppTheme appTheme) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: appTheme.secondaryBackground, // Bittersweet background
      width: double.infinity,
      padding: EdgeInsets.all(16),
      height: screenHeight * 0.45, // Adjust height to 45% of the screen height
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align content to the start
        children: [
          Text(
            _summaryText ?? AppLocalizations.of(context)!.summaryInformation,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: _isUrdu(_summaryText) ? TextAlign.right : TextAlign.left,
          ),
          SizedBox(height: 20), // Space between text and image
          Expanded(
            child: Image.asset(
              'assets/images/advice_scan.png',
              fit:
                  BoxFit.fill, // Changed to BoxFit.fill to cover the full width
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResultScreen(AppTheme appTheme) {
    // Include AppTheme parameter
    return SingleChildScrollView(
      child: Column(
        children: [
          buildSummarySection(appTheme), // Pass theme to the summary section
          Container(
            color: Colors.white, // White background for the rest
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatResponse(_responseText),
                  style: TextStyle(fontSize: 18, color: appTheme.primaryText),
                  textAlign:
                      _isUrdu(_responseText) ? TextAlign.right : TextAlign.left,
                ),
                SizedBox(height: 20),
                buildLinkPreview(_documentUrls),
                SizedBox(height: 20),
                actionButtons(appTheme), // Pass theme to buttons
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLinkPreview(List<String> urls) {
    // Get the screen width from the MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      // Set the height and width of the container
      height: 100, // Adjust height to fit the content
      width: screenWidth, // Limit the width to the screen width
      padding: EdgeInsets.all(8), // Padding around the container
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        itemBuilder: (context, index) => Container(
          width: screenWidth *
              0.7, // Set each preview item to take 80% of screen width
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AnyLinkPreview(
            link: urls[index],
            placeholderWidget: CircularProgressIndicator(),
            showMultimedia: false, // Adjust based on your needs
            bodyMaxLines: 5,
            backgroundColor: Colors.grey[100],
            borderRadius: 12,
            boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
            displayDirection:
                UIDirection.uiDirectionVertical, // Ensure it is vertical
          ),
        ),
      ),
    );
  }

  Widget actionButtons(AppTheme theme) {
    return Column(
      children: [
        MaterialButton(
          minWidth: double.infinity,
          height: 60,
          onPressed: () =>
              getAlternatives(_imageInfo!, userData!['userInfoMessage']),
          color: theme.tertiary400, // Use the Bittersweet color from theme
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Text(
            AppLocalizations.of(context)!.getAlternatives,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
          ),
        ),
        SizedBox(height: 20),
        MaterialButton(
          minWidth: double.infinity,
          height: 60,
          onPressed: () => Navigator.pushNamed(context, '/chatbot'),
          color: theme
              .secondaryColor, // Use a different color or the same as per your preference
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Text(
            AppLocalizations.of(context)!.continueChatting,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> pickImage(ImageSource source) async {
    var permissionStatus = await Permission.camera.request();
    if (permissionStatus.isGranted) {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _pickedImage = pickedFile;
          _isLoading = true;
        });
        sendImageToBackend(pickedFile);
      } else {
        print(AppLocalizations.of(context)!.noImageSelected);
      }
    } else {
      print(AppLocalizations.of(context)!.permissionDenied);
    }
  }

  Future<void> sendImageToBackend(XFile image) async {
    try {
      final bytes = await File(image.path).readAsBytes();
      String base64Image = base64Encode(bytes);
      String tenantId = FirebaseAuth.instance.currentUser?.uid ?? "defaultUser";
      // Get current language from the app settings
      String currentLanguage = Localizations.localeOf(context).languageCode;
      print("Debug: Current Language - ${userData?['userInfoMessage']}");
      var uuid = Uuid();
      var sessionID = uuid.v4(); // Generate a unique session ID
      var payload = {
        'image_base64': base64Image,
        'tenant_id': tenantId,
        'convo_id': sessionID,
        'user_info': userData?['userInfoMessage'] ?? 'default info',
        'language': currentLanguage,
      };

      var response = await http.post(
          Uri.parse(
              'https://us-central1-byte-e6f0c.cloudfunctions.net/scanning'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payload));

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print("Debug: Response Body - ${response.body}");

        // Check if 'documents' is present and not empty
        List<dynamic> documents = responseData['documents'] ?? [];
        List<String> newDocumentUrls = [];
        if (documents.isNotEmpty) {
          newDocumentUrls =
              List<String>.from(documents.map((doc) => doc['url'] as String));
        }

        setState(() {
          _responseText = responseData['response'];
          _documentUrls = newDocumentUrls;
          _imageInfo =
              responseData['image_info']; // Save the image info from response
          _summaryText = responseData['summary'];
          _isLoading = false;
        });
        print("Debug: ImageInfo - ${responseData['image_info']}");

        print("Debug: Document URLs - $_documentUrls");
      } else {
        print('Failed to send image: ${response.statusCode}');
        print('Error response body: ${response.body}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error sending image: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController?.dispose(); // Safely dispose of the controller
    super.dispose();
  }
}
