import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../alternatives/screens/alt_foods_screen.dart';
import '../../alternatives/models/product.dart';
import '../../../app_theme.dart';

// Add this extension at the top of your Dart file
extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  List<ChatMessage> messages = [];
  XFile? _pickedImage;
  Map<String, List<String>> messageLinks = {};
  late String conversationId; // Conversation ID for the session

  final TextEditingController _messageController = TextEditingController();
  final ChatUser byteUser = ChatUser(id: "byte", firstName: "BYTE");

  @override
  void initState() {
    super.initState();
    fetchUserData();
    generateConversationId();
  }

  // Generate a unique Conversation ID when the screen loads
  void generateConversationId() {
    var uuid = Uuid();
    conversationId = uuid.v4();
    print(
        "Hey I'm generating an id for this session thats unique"); // Generates a new UUID for the session
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage, // For accessing gallery and external storage
    ].request();

    final isPermitted = statuses[Permission.camera]!.isGranted &&
        statuses[Permission.storage]!.isGranted;
    if (!isPermitted) {
      // Handle the case where the user did not grant permissions.
      // You can choose to show an alert dialog or a permission rationale.
    }
  }

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

// Method to fetch and display alternatives based on image and user info
  Future<void> getAlternatives(String imageInfo, String userInfo) async {
    setState(() {
      _isSending = true; // Use _isSending to manage loading state
    });
    showLoadingDialog(context, AppLocalizations.of(context)!.fetching_alt);

    List<AltProduct> productsInfo = [];
    List<YtVideo> videosInfo = [];
    String productsErrorMessage = '';
    String videosErrorMessage = '';

    try {
      final generateSearchQueryResponse = await http.post(
        Uri.parse(
            'https://us-central1-byte-e6f0c.cloudfunctions.net/generate-search-query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nutr_label': imageInfo, 'user_info': userInfo}),
      );

      if (generateSearchQueryResponse.statusCode == 200) {
        final String generatedSearchQuery = generateSearchQueryResponse.body;
        print('Generated Search Query: $generatedSearchQuery');

        final fetchProductsFuture = http.post(
          Uri.parse(
              'https://us-central1-byte-e6f0c.cloudfunctions.net/get-alt-prods-links'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'search_query': generatedSearchQuery}),
        );

        final fetchVideosFuture = fetchVideos(generatedSearchQuery);

        final results = await Future.wait([
          fetchProductsFuture,
          fetchVideosFuture.catchError((e) {
            videosErrorMessage = 'Sorry, no relevant videos found';
            return []; // Return empty list on error
          })
        ]);

        final fetchProductsResponse = results[0] as http.Response;
        if (fetchProductsResponse.statusCode == 200) {
          final List<dynamic> productsInfoJson =
              jsonDecode(fetchProductsResponse.body);
          productsInfo = productsInfoJson
              .map((productJson) => AltProduct.fromJson(productJson))
              .toList();
        } else {
          productsErrorMessage = 'Sorry, no alternate products found';
        }

        videosInfo = results[1] as List<YtVideo>;
        if (videosInfo.isEmpty && videosErrorMessage.isEmpty) {
          videosErrorMessage = 'Sorry, no relevant videos found';
        }
      } else {
        productsErrorMessage = 'Sorry, no alternate products found';
        videosErrorMessage = 'Sorry, no relevant videos found';
      }
    } catch (e) {
      print('An error occurred: $e');
      productsErrorMessage = 'Sorry, no alternate products found';
      videosErrorMessage = 'Sorry, no relevant videos found';
    } finally {
      hideLoadingDialog(context);
      setState(() {
        _isSending = false;
      });

      if (productsInfo.isNotEmpty || videosInfo.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AltProductListingWidget(
                      altProducts: productsInfo,
                      ytVideos: videosInfo,
                      productsErrorMessage: productsErrorMessage,
                      videosErrorMessage: videosErrorMessage,
                    )));
      }
    }
  }

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

// Modified fetchUserData function
  Future<void> fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userDocument = await FirebaseFirestore.instance
            .collection('user_health_data')
            .doc(user!.uid)
            .get();
        if (userDocument.exists) {
          setState(() {
            userData = userDocument.data() as Map<String, dynamic>?;
            // Ensure userData is not null before using it
            if (userData != null) {
              // Safe access using null check
              userData!['userInfoMessage'] = generateUserInfoMessage(userData!);
            }
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  bool _isSending = false;

// Use this userInfoMessage safely
  void onSendPressed() async {
    if (_messageController.text.isNotEmpty && !_isSending) {
      print("Debug: Sending message");
      setState(() {
        _isSending = true;
        // Show BYTE is typing
        byteUser.customProperties = {'isTyping': true};
      });

      // Prepare and send the message without user info in the displayed text
      final ChatMessage message = ChatMessage(
        text: _messageController.text,
        user: ChatUser(id: user!.uid),
        createdAt: DateTime.now(),
        medias: _pickedImage != null
            ? [
                ChatMedia(
                    url: _pickedImage!.path,
                    fileName: _pickedImage!.name,
                    type: MediaType.image)
              ]
            : null,
      );

      onSend(message);

      _isSending = false; // Reset after the response is processed
    }
  }

  void onSend(ChatMessage message) async {
    print(
        "Message being sent with text: ${message.text} and image: ${message.medias?.first.url}");

    var uuid = Uuid();
    String messageId = uuid.v4(); // Generates a unique ID
    String currentLanguage = Localizations.localeOf(context).languageCode;

    String? base64Image;
    if (_pickedImage != null) {
      final bytes = await File(_pickedImage!.path).readAsBytes();
      base64Image = base64Encode(bytes);
    }

    setState(() {
      messages.insert(0, message);
      _pickedImage = null;
      _messageController.clear();
    });

    base64Image = base64Image; // Ensure base64Image is not null
    print("convo id thats sent to cohere");
    print(conversationId);
    print(user!.uid);
    var payload = {
      'user_message': message.text,
      'convo_id': conversationId,
      'tenant_id': user!.uid,
      'user_info': userData?['userInfoMessage'],
      'language': currentLanguage,
      'image_base64': base64Image
    };

    var response = await http.post(
        Uri.parse(
            'https://us-central1-byte-e6f0c.cloudfunctions.net/final-chatbot'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload));

    print('HTTP Response Status: ${response.statusCode}');
    print('HTTP Response Body: ${response.body}');
    // Insert the text response into the chat
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<String> urls = (responseData['documents'] as List)
          .map((doc) => doc['url'].toString())
          .toList();

      setState(() {
        // Existing logic to handle the response text and URLs
        messages.insert(
            0,
            ChatMessage(
              text: responseData['response'],
              user: ChatUser(id: "responseBot"),
              createdAt: DateTime.now(),
            ));

        if (urls.isNotEmpty) {
          messageLinks[messageId] = urls;
          messages.insert(
              0,
              ChatMessage(
                text: "View Sources",
                user: ChatUser(id: "sourceBot"),
                createdAt: DateTime.now(),
                customProperties: {'isSource': true, 'messageId': messageId},
              ));
        }

        // New logic to add 'Get Alternatives' message if there was an image sent
        if (message.medias != null && message.medias!.isNotEmpty) {
          messages.insert(
              0,
              ChatMessage(
                  text: "Get Alternatives",
                  user: ChatUser(id: "system"),
                  createdAt: DateTime.now(),
                  customProperties: {
                    'action': 'getAlternatives',
                    'image_info': responseData[
                        'image_info'], // Ensure the cloud function returns this data
                    'user_info': userData?['userInfoMessage']
                  }));
        }
      });

      // Reset the sending state and other UI updates if needed
      setState(() {
        _isSending = false; // Re-enable send button
        byteUser.customProperties = {
          'isTyping': false
        }; // Hide typing indicator
      });

      // Existing handling for failure or errors in response
      if (_pickedImage != null && response.statusCode != 200) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  }

  Widget buildLinkPreview(List<String> urls) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (_, controller) => Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black26,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.drag_handle),
            Expanded(
              child: ListView.separated(
                controller: controller,
                separatorBuilder: (_, __) => Divider(),
                itemCount: urls.length,
                itemBuilder: (_, index) => AnyLinkPreview(
                  link: urls[index],
                  displayDirection: UIDirection.uiDirectionVertical,
                  placeholderWidget: CircularProgressIndicator(),
                  backgroundColor: Colors.grey[100],
                  borderRadius: 12,
                  boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context); // Get your theme data

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.byteChatTitle),
      ),
      body: userData == null
          ? CircularProgressIndicator()
          : Stack(
              // Wrap in a Stack to layer widgets on top of each other
              children: [
                Column(
                  // This Column contains the chat messages and input box
                  children: [
                    Expanded(
                      child: DashChat(
                        currentUser: ChatUser(id: user!.uid),
                        typingUsers:
                            byteUser.customProperties?['isTyping'] == true
                                ? [byteUser]
                                : [],
                        onSend: onSend,
                        messages: messages,
                        messageOptions: MessageOptions(
                          showOtherUsersAvatar: false,
                          
                          messageDecorationBuilder: (message, _, __) =>
                              messageDecoration(message, theme),
                          maxWidth: MediaQuery.of(context).size.width *
                              0.7, // Adjust max width to 80% of screen width
                          marginDifferentAuthor: EdgeInsets.only(
                              top:
                                  2), // Reduced spacing between different authors
                          marginSameAuthor: EdgeInsets.only(
                              top:
                                  2), // Reduced spacing between same author messages

                          messageTextBuilder: (message, _, __) {
                            if (message.customProperties?['isSource'] == true) {
                              return Text(
                                message.text,
                                style: TextStyle(
                                    color: Colors
                                        .white), // White text for better contrast
                              );
                            } else if (message.customProperties?['action'] ==
                                'getAlternatives') {
                              return Text(
                                message.text,
                                style: TextStyle(
                                    color: Colors
                                        .white), // White text for better contrast
                              );
                            } else {
                              return Text(
                                message.text,
                                style: TextStyle(
                                    color: Colors.black), // Default text color
                              );
                            }
                          },
                          currentUserContainerColor: Color(0xFFFC7562), // Use the tertiary color from your theme
                          currentUserTextColor: Colors.white, // Adjust te
                          onPressMessage: (message) {
                            if (message.customProperties?['isSource'] == true) {
                              String messageId =
                                  message.customProperties!['messageId'];
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => buildLinkPreview(
                                    messageLinks[messageId] ?? []),
                                isScrollControlled: true,
                              );
                            } else if (message.customProperties?['action'] ==
                                'getAlternatives') {
                              if (message.customProperties != null) {
                                String imageInfo =
                                    message.customProperties!['image_info'];
                                String userInfo =
                                    message.customProperties!['user_info'];
                                getAlternatives(imageInfo, userInfo);
                              }
                            }
                          },
                        ),
                        inputOptions: InputOptions(
                          sendButtonBuilder: (function) {
                            return IconButton(
                              icon: Icon(Icons.send),
                              onPressed: _isSending ? null : onSendPressed,
                              color: _isSending
                                  ? Colors.grey
                                  : Theme.of(context).iconTheme.color,
                            );
                          },
                          textController: _messageController,
                          inputToolbarPadding: EdgeInsets.only(
                              left: 10 +
                                  (_pickedImage != null
                                      ? 50
                                      : 0), // make space for the image if it exists
                              right: 10,
                              bottom: 10),
                          trailing: [
                            IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () => pickImage(ImageSource.camera),
                            ),
                            IconButton(
                              icon: Icon(Icons.photo_library),
                              onPressed: () => pickImage(ImageSource.gallery),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // The image preview on top of the chat input
                if (_pickedImage != null)
                  Positioned(
                    // Use Positioned to place the preview exactly where we want it
                    bottom: 10, // Same as inputToolbarPadding.bottom
                    left: 10, // Same as inputToolbarPadding.left
                    child: Stack(
                      children: [
                        Container(
                          width: 40, // The size of the tiny image box
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // You might want to change this as per your UI design
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_pickedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _pickedImage = null;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(
                                    0.6), // Makes the icon more visible against any background
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  BoxDecoration messageDecoration(ChatMessage message, AppTheme theme) {
    bool isSource = message.customProperties?['isSource'] ?? false;
    bool isGetAlternatives =
        message.customProperties?['action'] == 'getAlternatives';

    if (isSource) {
      return BoxDecoration(
        color: theme.secondaryColor, // Light gray background for View Sources
        borderRadius: BorderRadius.circular(18), // Rounded corners
      );
    } else if (isGetAlternatives) {
      return BoxDecoration(
        color: theme
            .tertiary400, // Bittersweet color from theme for Get Alternatives
        borderRadius: BorderRadius.circular(18), // Rounded corners
      );
    } else {
      return BoxDecoration(
        color: Color(0xFFF5F5F5), // Default color for other messages
        borderRadius: BorderRadius.circular(10),
      );
    }
  }

  Future<void> pickImage(ImageSource source) async {
    // Request the appropriate permission from the user
    Permission permission;
    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      permission = Platform.isIOS ? Permission.photos : Permission.storage;
    }

    var permissionStatus = await permission.request();

    // Proceed only if permissions have been granted
    if (permissionStatus.isGranted) {
      try {
        final pickedFile = await ImagePicker().pickImage(source: source);
        if (pickedFile != null) {
          setState(() {
            _pickedImage = pickedFile;
          });
        }
      } catch (e) {
        // If an error occurs, log the error to the console.
        print(e);
      }
    } else {
      // If permissions are denied, display a message to the user.
      print('Permission denied. Cannot access the gallery.');
    }
  }
}
