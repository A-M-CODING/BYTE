// lib/features/community/widgets/poll_widget.dart
import 'package:flutter/material.dart';

class PollWidget extends StatefulWidget {
  final String question;
  final Map<String, int> votes;
  final List<String> options;
  final Function(String question, String option) onVote;

  const PollWidget({
    Key? key,
    required this.question,
    required this.votes,
    required this.options,
    required this.onVote,
  }) : super(key: key);

  @override
  _PollWidgetState createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  late Map<String, int> localVotes;

  @override
  void initState() {
    super.initState();
    localVotes = Map.from(widget.votes);
  }

  void handleVote(String option) {
    setState(() {
      localVotes.update(option, (value) => value + 1, ifAbsent: () => 1);
    });
    widget.onVote(widget.question, option);
  }

  @override
  Widget build(BuildContext context) {
    int totalVotes = localVotes.values.fold(0, (previousValue, element) => previousValue + element);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.question, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
        ...widget.options.map((option) {
          double votePercent = totalVotes > 0 ? (localVotes[option] ?? 0) / totalVotes * 100 : 0.0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ElevatedButton(
              onPressed: () => handleVote(option),
              child: Text("$option (${votePercent.toStringAsFixed(1)}%)"),
            ),
          );
        }).toList(),
      ],
    );
  }
}
