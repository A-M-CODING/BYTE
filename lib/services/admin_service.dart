// lib/services/admin_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // A method to check if the current user is an admin
  Future<bool> isAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false; // No user is signed in.
    }
    final userId = user.uid;

    try {
      // Adjust the path to your actual document ID and field
      final docSnapshot = await _firestore.collection('admin').doc('3x0nxadMOfnB1vbsPQWN').get();
      if (docSnapshot.exists) {
        List<dynamic> adminUserIds = docSnapshot.data()?['adminuserids'] as List<dynamic>;
        // Check if the current user's UID exists in the list of admin IDs
        return adminUserIds.contains(userId);
      }
      return false;
    } catch (e) {
      // Handle any errors here
      print('An error occurred while checking admin status: $e');
      return false; // Default to non-admin if there's an error.
    }
  }
}
