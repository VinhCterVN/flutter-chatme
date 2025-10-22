import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> signIn({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      await saveUserData(userCredential.user!);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        default:
          return e.message ?? 'An error occurred during sign-in.';
      }
    }
  }

  Future<String?> signUp({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.sendEmailVerification();
      await saveUserData(userCredential.user!);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'The email address is already in use by another account.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'weak-password':
          return 'The password is too weak.';
        default:
          return e.message ?? 'An error occurred during sign-up.';
      }
    }
  }

  Future<String?> updateUserDisplayName(String displayName) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return 'No user is currently signed in.';
      }
      await user.updateDisplayName(displayName.trim());
      await user.reload();
      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser?.displayName == displayName.trim()) {
        return null; // Success
      } else {
        return 'Failed to update displayName.';
      }
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred while updating the display name.';
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }

  Future<String?> sendVerificationEmail() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) return 'No user is currently signed in.';
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        log("Verification email sent to ${user.email}");
        return null;
      }
      return 'Email is already verified.';
    } catch (e) {
      log("Error sending verification email: $e");
      return e.toString();
    }
  }

  Future<String?> saveUserData(User user) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users');
      await userRef.doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? '',
        'photoUrl': user.photoURL ?? '',
        'emailVerified': user.emailVerified,
        'lastActive': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return null;
    } catch (e) {
      log("Error saving user data: $e");
      return 'Failed to save user data: $e';
    }
  }

  Future<void> signOut() async {
    await FirebaseFirestore.instance.collection('users').doc(_firebaseAuth.currentUser?.uid).update({
      'lastActive': FieldValue.serverTimestamp(),
    });

    await _firebaseAuth.signOut();
  }
}
