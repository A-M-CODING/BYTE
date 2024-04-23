
import 'package:cloud_firestore/cloud_firestore.dart';

class PollService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> voteOnPoll(String postId, String option) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'votes.$option': FieldValue.increment(1)
      });
    } catch (e) {
      // Handle the error, maybe by rolling back the local state change
      print('Error voting on poll: $e');
    }
  }
}
