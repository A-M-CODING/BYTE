// // lib/features/community/widgets/poll_widget.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byte_app/features/community/services/poll_service.dart';
import 'package:byte_app/app_theme.dart';

class PollWidget extends StatefulWidget {
  final String postId;
  final String question;
  final Map<String, List<String>> votes; // Update the type to Map<String, List<String>>
  final List<String> options;
  final Function(String question, String option) onVote;

  const PollWidget({
    Key? key,
    required this.postId,
    required this.question,
    required this.votes,
    required this.options,
    required this.onVote,
  }) : super(key: key);

  @override
  _PollWidgetState createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  late Map<String,
      List<String>> localVotes; // Update the type to Map<String, List<String>>

  @override
  void initState() {
    super.initState();
    localVotes = Map.from(widget.votes);
  }

  void handleVote(String option) {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return; // Ensure there is a logged-in user

    setState(() {
      if (localVotes[option]?.contains(currentUser.uid) ?? false) {
        localVotes[option]?.remove(currentUser.uid);
      } else {
        (localVotes[option] ??= []).add(currentUser.uid);
      }
    });

    // Save or update this to the database
    PollService().voteOnPoll(widget.postId, option).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to vote: $e')));
    });

    widget.onVote(widget.question, option);
  }

  @override
  Widget build(BuildContext context) {
    int totalVotes = localVotes.values.fold(0, (sum, list) => sum + list.length);
    AppTheme theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              widget.question,
              style: theme.typography.bodyText22.copyWith(fontWeight: FontWeight.bold, fontSize: 18.0)
          ),
          const SizedBox(height: 10),
          ...widget.options.map((option) => buildOption(context, option, totalVotes)).toList(),
        ],
      ),
    );
  }

  Widget buildOption(BuildContext context, String option, int totalVotes) {
    double votePercent = totalVotes > 0 ? (localVotes[option]?.length ?? 0) / totalVotes * 100 : 0.0;
    bool isVotedByUser = localVotes[option]?.contains(FirebaseAuth.instance.currentUser?.uid) ?? false;
    // Retrieve the theme
    AppTheme theme = AppTheme.of(context);


    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        onPressed: () => handleVote(option),
        style: ElevatedButton.styleFrom(
          backgroundColor: isVotedByUser ? theme.secondaryBackground : theme.primaryBtnText,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(option, style: TextStyle(color: isVotedByUser ? Colors.white : Colors.black)),
            Text('${votePercent.toStringAsFixed(1)}%', style: theme.typography.bodyText22.copyWith(color: isVotedByUser ? Colors.white : Colors.black))
          ],
        ),
      ),
    );
  }
}