// lib/features/community/services/poll_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class PollService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> voteOnPoll(String postId, String option) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    var userId = currentUser?.uid;

    if (userId == null) return; // No user logged in

    var postRef = _firestore.collection('posts').doc(postId);
    var snapshot = await postRef.get();
    var votes = Map<String, dynamic>.from(snapshot.data()?['votes'] ?? {});
    var userVotes = (votes[option] as List<dynamic>?)?.cast<String>() ?? [];

    if (userVotes.contains(userId)) {
      // User already voted this option, remove the vote
      userVotes.remove(userId);
    } else {
      // Add new vote
      userVotes.add(userId);
    }

    // Update the votes
    await postRef.update({
      'votes.$option': userVotes,
    });
  }
}
