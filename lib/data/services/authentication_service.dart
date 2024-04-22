// lib/data/services/authentication_service.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> signIn({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid; // Return the user ID or null if the sign-in fails
    } on FirebaseAuthException catch (e) {
      // You can handle specific errors like e.code == 'user-not-found' here
      return e.message; // Return the error message
    }
  }

  Future<String?> signUp({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid; // Return the user ID or null if the sign-up fails
    } on FirebaseAuthException catch (e) {
      // Handle specific errors
      return e.message; // Return the error message
    }
  }
}
