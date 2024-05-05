import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {

  Future<Uri> createDynamicLink(String postId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://byte.page.link',
      link: Uri.parse('https://yourapp.com/postDetail?postId=$postId'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.byte_app', // Make sure this matches your package name in Android
        minimumVersion: 0,
        fallbackUrl: Uri.parse('https://byte-apk.streamlit.app/'),
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.example.byte_app', // Replace with your iOS bundle ID
        minimumVersion: '0',
        appStoreId: 'your_app_store_id', // Replace with your App Store ID
        fallbackUrl: Uri.parse('https://byte-apk.streamlit.app/'), // Fallback URL for iOS
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Check out this post on BYTE',
        description: 'This is an amazing post that you must see!',
        imageUrl: Uri.parse('https://yourapp.com/images/post-thumbnail.jpg'),
      ),
      // Additional parameters here as needed
    );

    final ShortDynamicLink shortDynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    final Uri dynamicLink = shortDynamicLink.shortUrl;

    print('Dynamic Link Created: $dynamicLink');

    return dynamicLink;
  }
}
