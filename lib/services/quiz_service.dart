import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizService {
  QuizService._();
  static final QuizService instance = QuizService._();

  static const _prefsKey = 'quiz_high_score';
  
  final ValueNotifier<int> highScore = ValueNotifier(0);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    highScore.value = prefs.getInt(_prefsKey) ?? 0;
  }

  Future<void> updateHighScore(int currentScore) async {
    if (currentScore > highScore.value) {
      highScore.value = currentScore;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefsKey, currentScore);
    }
  }
}