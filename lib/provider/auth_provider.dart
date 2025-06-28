import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _fireAuth = FirebaseAuth.instance;

class AuthProvider extends ChangeNotifier {
  final form = GlobalKey<FormState>();

  var islogin = true;
  var enteredEmail = '';
  var enteredPassword = '';

  void submit() async {
    final _isvalid = form.currentState!.validate();

    if (!_isvalid) {
      return;
    }

    form.currentState!.save();

    try {
      if (islogin) {
        // Perform login
        final UserCredential = await _fireAuth.signInWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,
        );
        // print('Logging in with email: $enteredEmail and password: $enteredPassword');
      } else {
        // Perform signup
        final UserCredential = await _fireAuth.createUserWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,
        );
        // print('Signing up with email: $enteredEmail and password: $enteredPassword');
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          print('Email already in use. Please try another email.');
        }
        // else if (e.code == 'invalid-email') {
        //   print('Invalid email format. Please enter a valid email.');
        // } else if (e.code == 'weak-password') {
        //   print('Weak password. Please enter a stronger password.');
        // } else {
        //   print('An error occurred: ${e.message}');
        // }
      }
    }

    notifyListeners();
  }
}
