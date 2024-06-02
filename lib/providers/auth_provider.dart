import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class MyAuthProvider with ChangeNotifier {
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  MyAuthProvider(this._firebaseAuth, this._firestore);

  Stream<auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signUp(String email, String username, String password,
      BuildContext context) async {
    try {
      auth.UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      auth.User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();

        User newUser = User(
          uid: user.uid,
          email: user.email!,
          username: username,
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Check Your Email'),
              content: Text(
                  'An email verification link has been sent. Please verify your email to sign in.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/signin');
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      auth.User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        throw Exception(
            'Please verify your email address. A verification email has been sent.');
      }

      if (user != null && user.emailVerified) {
        notifyListeners(); // Notify listeners to update the UI
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        throw Exception('Invalid email or password.');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      notifyListeners(); // Notify listeners to update the UI
      Navigator.pushReplacementNamed(context, '/signin');
    } catch (e) {
      throw e;
    }
  }

  Future<void> sendPasswordResetEmail(
      String email, BuildContext context) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset'),
            content: Text(
                'An email has been sent to $email to reset your password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/signin');
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      throw e;
    }
  }
}
