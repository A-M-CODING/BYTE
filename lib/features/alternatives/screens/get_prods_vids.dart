// // this can be deleted - is of no use

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'alt_foods_screen.dart';
// import '../models/product.dart';
// import 'user_favourites.dart';
// import '../../profile/screens/profile_page.dart';

// Future<List<YtVideo>> fetchVideos(String searchQuery) async {
//   final videoResponse = await http.post(
//     Uri.parse(
//         'https://us-central1-byte-e6f0c.cloudfunctions.net/get-youtube-links'),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({'search_query': searchQuery}),
//   );

//   if (videoResponse.statusCode == 200) {
//     final List<dynamic> videosInfoJson = jsonDecode(videoResponse.body);
//     return videosInfoJson
//         .map((videoJson) => YtVideo.fromJson(videoJson))
//         .toList();
//   } else {
//     throw Exception('Failed to load videos');
//   }
// }

// class GetProdsVidsPage extends StatefulWidget {
//   final String imageInfo;
//   final String userInfo;

//   GetProdsVidsPage({required this.imageInfo, required this.userInfo});
//   @override
//   State<StatefulWidget> createState() => _GetProdsVidsPageState();
// }

// class _GetProdsVidsPageState extends State<GetProdsVidsPage> {
//   Future<void> getAlternatives() async {
//     // Use widget.imageInfo and widget.userInfo directly
//     final String nutritionLabel = widget.imageInfo;
//     final String userInfo = widget.userInfo;
//     List<AltProduct> productsInfo = [];
//     List<YtVideo> videosInfo = [];
//     String productsErrorMessage = '';
//     String videosErrorMessage = '';

//     try {
//       // Call the generate-search-query Cloud Function
//       final generateSearchQueryResponse = await http.post(
//         Uri.parse(
//             'https://us-central1-byte-e6f0c.cloudfunctions.net/generate-search-query'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'nutr_label': nutritionLabel, 'user_info': userInfo}),
//       );

//       if (generateSearchQueryResponse.statusCode == 200) {
//         // Assuming the response is plain text, not JSON.
//         final String generatedSearchQuery = generateSearchQueryResponse.body;
//         print('Generated Search Query: $generatedSearchQuery');

//         // Prepare Future calls for fetching products and videos
//         final fetchProductsFuture = http.post(
//           Uri.parse(
//               'https://us-central1-byte-e6f0c.cloudfunctions.net/get-alt-prods-links'),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({'search_query': generatedSearchQuery}),
//         );

//         final fetchVideosFuture = fetchVideos(generatedSearchQuery);

//         // Execute both Future calls in parallel
//         final results = await Future.wait([
//           fetchProductsFuture,
//           fetchVideosFuture.catchError((e) {
//             videosErrorMessage = 'Sorry, no relevant videos found';
//             return []; // Return empty list on error
//           })
//         ]);

//         // Handle products response
//         final fetchProductsResponse = results[0] as http.Response;
//         if (fetchProductsResponse.statusCode == 200) {
//           final List<dynamic> productsInfoJson =
//               jsonDecode(fetchProductsResponse.body);
//           productsInfo = productsInfoJson
//               .map((productJson) => AltProduct.fromJson(productJson))
//               .where((product) =>
//                   product.name != null &&
//                   product.name.isNotEmpty &&
//                   product.name !=
//                       "No Title Found" && // Exclude products with "No Title Found"
//                   product.image != null &&
//                   product.image.isNotEmpty)
//               .toList();

//           if (productsInfo.isEmpty) {
//             productsErrorMessage = 'Sorry, no alternate products found';
//           }
//         } else {
//           productsErrorMessage = 'Sorry, no alternate products found';
//         }
//         // Handle videos response
//         videosInfo = results[1] as List<YtVideo>;
//         if (videosInfo.isEmpty && videosErrorMessage.isEmpty) {
//           videosErrorMessage = 'Sorry, no relevant videos found';
//         }
//       } else {
//         productsErrorMessage = 'Sorry, no alternate products found';
//         videosErrorMessage = 'Sorry, no relevant videos found';
//         print(
//             'Failed to generate search query: ${generateSearchQueryResponse.statusCode}');
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//       productsErrorMessage = 'Sorry, no alternate products found';
//       videosErrorMessage = 'Sorry, no relevant videos found';
//     }

//     // Navigate to AltFoodsScreen with the fetched products and videos
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AltProductListingWidget(
//           altProducts: productsInfo,
//           ytVideos: videosInfo,
//           productsErrorMessage: productsErrorMessage,
//           videosErrorMessage: videosErrorMessage,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // UI code that was previously there, possibly remove TextFields since you're passing data directly.
//     return Scaffold(
//       // existing scaffold setup
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Fetching Alternatives...',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 24.0),
//             ElevatedButton(
//               child: Text('Fetch Alternatives'),
//               onPressed: getAlternatives,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
