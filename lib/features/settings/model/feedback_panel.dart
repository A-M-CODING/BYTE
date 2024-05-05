import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byte_app/app_theme.dart';

class FeedbackPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context); // Get the app theme

    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.feedback,
        style: appTheme.bodyText1, // Use bodyText1 style from the app theme
      ),
      leading: Icon(Icons.feedback,
          color: appTheme.primaryColor), // Set icon color to primary color
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => FeedbackDialog(),
        );
      },
    );
  }
}

class FeedbackDialog extends StatefulWidget {
  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  Future<void> _submitFeedback() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final Map<String, dynamic> feedbackData = {
      'userId': userId,
      'rating': _rating,
      'review': _reviewController.text.trim(),
      'date': FieldValue.serverTimestamp(),
    };

    // Save the feedback to the database
    await FirebaseFirestore.instance.collection('feedback').add(feedbackData);

    // Clear the text field and dismiss the dialog
    _reviewController.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.feedback),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(AppLocalizations.of(context)!.rateExperience),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
              itemSize:
                  20.0, // Adjust the size to your preference, 20.0 is just an example
            ),
            SizedBox(
                height:
                    8), // Add some space between the rating bar and text field
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.writeReview,
                border: OutlineInputBorder(), // Add a border to the TextField
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 8, vertical: 8), // Reduce padding
              ),
              maxLength: 200, // Set a character limit for the review
              maxLines: 3, // Limit the number of lines in the TextField
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.submit),
          onPressed: _submitFeedback,
        ),
      ],
    );
  }
}
