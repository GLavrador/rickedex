import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorHelper {
  static String getFriendlyMessage(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          return 'Invalid email or password.';
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'weak-password':
          return 'Password is too weak.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'too-many-requests':
          return 'Too many attempts. Try again later.';
        default:
          return e.message ?? 'An unknown authentication error occurred.';
      }
    }
    return e.toString().replaceAll("Exception: ", "");
  }
}