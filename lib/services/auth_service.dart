import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with phone number
  Future<void> signInWithPhoneNumber(BuildContext context, String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verification failed: ${e.message}")));
        },
        codeSent: (String verificationId, int? resendToken) {
          // Show OTP input screen to the user
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print("Error during phone number login: $e");
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Re-verify after 3 months
  Future<void> checkForReVerification(BuildContext context) async {
    final user = _auth.currentUser;
    if (user != null) {
      final now = DateTime.now();
      final lastSignIn = user.metadata.lastSignInTime ?? DateTime.now();
      final diff = now.difference(lastSignIn).inDays;

      if (diff >= 90) { // If more than 3 months have passed
        await signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please re-verify your phone number")),
        );
      }
    }
  }
}
