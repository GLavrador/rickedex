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
        
        await QuizService.instance.syncWithCloud(user);
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

    final qService = QuizService.instance;
    
    final newUser = AppUser(
      id: credential.user!.uid,
      email: email,
      nickname: nickname,
      highScoreEasy: qService.highScoreEasy.value,
      highScoreMedium: qService.highScoreMedium.value,
      highScoreHard: qService.highScoreHard.value,
    );

    await _db.collection('users').doc(newUser.id).set(newUser.toMap());
    
    currentUser.value = newUser;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}