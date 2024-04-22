// lib/features/community/screens/post.dart
import 'package:flutter/material.dart';
import 'posts/text_post_screen.dart'; // Changed
import 'posts/image_post_screen.dart'; // Changed
import 'posts/poll_post_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PostScreen extends StatelessWidget {
  final PanelController panelController;

  PostScreen({Key? key, required this.panelController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Post'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => panelController.close(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TextPostScreen())),
              child: Text('Create Text Post'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePostScreen())),
              child: Text('Create Image Post'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PollPostScreen())),
              child: Text('Create Poll'),
            ),
          ],
        ),
      ),
    );
  }
}
