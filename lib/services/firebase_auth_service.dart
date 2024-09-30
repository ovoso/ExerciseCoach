import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

// Service class to handle Firebase Authentication
class FirebaseAuthService {
  // Instance of FirebaseAuth to interact with Firebase Authentication
  FirebaseAuth auth = FirebaseAuth.instance;

  // Function to log in a user using email and password
  Future login(String email, String password) async {
    // Sign in with email and password
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Function to sign up a new user using email and password
  Future signup(String email, String password) async {
    // Create a new user with email and password
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Function to log in a user using Google Sign-In
  Future logininwithgoogle() async {
    // Trigger the Google Sign-In process
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain authentication details from the Google sign-in request
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential using the authentication details
    AuthCredential myCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Use the credential to sign in to Firebase
    UserCredential user =
    await FirebaseAuth.instance.signInWithCredential(myCredential);

    // Print the user's display name for debugging purposes
    debugPrint(user.user?.displayName);
  }
}
