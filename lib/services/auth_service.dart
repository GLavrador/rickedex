import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rick_morty_app/models/app_user.dart';
import 'package:rick_morty_app/services/quiz_service.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final ValueNotifier<AppUser?> currentUser = ValueNotifier(null);

  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  Future<void> init() async {
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        currentUser.value = null;
      } else {
        await _fetchUserDetails(firebaseUser.uid);
      }
    });
  }

  Future<void> _fetchUserDetails(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      
      if (doc.exists) {
        final user = AppUser.fromMap(doc.data()!);
        currentUser.value = user;
        
        await _auth.currentUser?.reload();
        await QuizService.instance.overwriteLocalWithCloud(user);
      }
    } catch (e) {
      debugPrint("Auth Error: $e");
    }
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String nickname,
  }) async {
    final nickCheck = await _db
        .collection('users')
        .where('nickname', isEqualTo: nickname)
        .get();

    if (nickCheck.docs.isNotEmpty) {
      throw Exception("Nickname '$nickname' is already taken.");
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) throw Exception("Registration failed.");

    await credential.user!.sendEmailVerification();

    final newUser = AppUser(
      id: credential.user!.uid,
      email: email,
      nickname: nickname,
      highScoreEasy: 0,
      highScoreMedium: 0,
      highScoreHard: 0,
      isVerified: false,
    );

    await _db.collection('users').doc(newUser.id).set(newUser.toMap());
    
    currentUser.value = newUser;
  }

  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
    final verified = _auth.currentUser?.emailVerified ?? false;
    
    final user = currentUser.value;
    if (user != null) {
      if (user.isVerified != verified) {
        await _db.collection('users').doc(user.id).update({'isVerified': verified});
      }

      currentUser.value = AppUser(
        id: user.id,
        email: user.email,
        nickname: user.nickname,
        highScoreEasy: user.highScoreEasy,
        highScoreMedium: user.highScoreMedium,
        highScoreHard: user.highScoreHard,
        isVerified: verified,
      );
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await QuizService.instance.resetLocalScores();
  }
}