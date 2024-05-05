// lib/features/community/screens/post.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'posts/text_post_screen.dart';
import 'posts/image_post_screen.dart';
import 'posts/poll_post_screen.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:byte_app/app_theme.dart';

class PostScreen extends StatefulWidget {
  // final PanelController panelController;
  //
  // PostScreen({Key? key, required this.panelController}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  double opacityText = 0.0;
  double opacityImage = 0.0;
  double opacityPoll = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 300), () {
      setState(() => opacityText = 1.0);
    });
    Timer(Duration(milliseconds: 600), () {
      setState(() => opacityImage = 1.0);
    });
    Timer(Duration(milliseconds: 900), () {
      setState(() => opacityPoll = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context); // Access theme for styling

    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Post'),
        centerTitle: true,
      ),


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch buttons across the column width
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AnimatedOpacity(
              opacity: opacityText,
              duration: Duration(milliseconds: 300),
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TextPostScreen())),
                child: Text('Create Text Post', style: theme.typography.subtitle11.copyWith(color: theme.primaryBtnText)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.secondaryBackground,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 10.0), // Padding for button height
                ),
              ),
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: opacityImage,
              duration: Duration(milliseconds: 300),
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePostScreen())),
                child: Text('Create Image Post', style: theme.typography.subtitle11.copyWith(color: theme.primaryBtnText)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.secondaryBackground,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 10.0), // Padding for button height
                ),
              ),
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: opacityPoll,
              duration: Duration(milliseconds: 300),
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PollPostScreen())),
                child: Text('Create Poll', style: theme.typography.subtitle11.copyWith(color: theme.primaryBtnText)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.secondaryBackground,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 10.0), // Padding for button height
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
