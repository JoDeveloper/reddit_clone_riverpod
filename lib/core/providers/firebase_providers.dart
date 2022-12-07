import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Creating a provider for FirebaseAuth.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Creating a provider for FirebaseFirestore.
final fireStorageProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Creating a provider for GoogleSignIn.
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});
