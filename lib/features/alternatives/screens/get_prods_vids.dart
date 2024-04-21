import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'alt_foods_screen.dart';
import '../models/product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetProdsVidsPage(),
    );
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

class GetProdsVidsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetProdsVidsPageState();
}

class _GetProdsVidsPageState extends State<GetProdsVidsPage> {
  final TextEditingController _nutritionLabelController =
      TextEditingController();
  final TextEditingController _userInfoController = TextEditingController();

  Future<void> getAlternatives() async {
    final String nutritionLabel = _nutritionLabelController.text;
    final String userInfo = _userInfoController.text;

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

        // Call the fetch_alternate_products Cloud Function with the generated search query
        final fetchProductsResponse = await http.post(
          Uri.parse(
              'https://us-central1-byte-e6f0c.cloudfunctions.net/get-alt-prods-links'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'search_query': generatedSearchQuery}),
        );

        if (fetchProductsResponse.statusCode == 200) {
          // Print the JSON response
          print('Fetched Products JSON: ${fetchProductsResponse.body}');

          // Parse the JSON into a list of AltProduct objects
          final List<dynamic> productsInfoJson =
              jsonDecode(fetchProductsResponse.body);
          final List<AltProduct> productsInfo =
              productsInfoJson.map((productJson) {
            return AltProduct.fromJson(productJson);
          }).toList();

          // Navigate to AltFoodsScreen with the fetched products
          final videosInfo = await fetchVideos(generatedSearchQuery);
          // Now navigate with both products and videos
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AltProductListingWidget(
                altProducts: productsInfo,
                ytVideos: videosInfo, // Add this line to pass the videos
              ),
            ),
          );
        } else {
          print(
              'Failed to fetch products info: ${fetchProductsResponse.statusCode}');
        }
      } else {
        print(
            'Failed to generate search query: ${generateSearchQueryResponse.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
        ),
        title: Text('Get Alternatives'),
        actions: [
          IconButton(
            icon: Icon(Icons.shop),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/altFoods'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutrition Label',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _nutritionLabelController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter nutrition info',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'User Info',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _userInfoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter user info',
              ),
            ),
            SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                child: Text('Get Alternatives'),
                onPressed: getAlternatives,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
