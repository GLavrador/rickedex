import 'package:flutter/foundation.dart';
import 'package:rick_morty_app/models/quiz_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizService {
  QuizService._();
  static final QuizService instance = QuizService._();

  final ValueNotifier<int> highScoreEasy = ValueNotifier(0);
  final ValueNotifier<int> highScoreMedium = ValueNotifier(0);

  static const _keyEasy = 'quiz_high_score_easy';
  static const _keyMedium = 'quiz_high_score_medium';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    highScoreEasy.value = prefs.getInt(_keyEasy) ?? 0;
    highScoreMedium.value = prefs.getInt(_keyMedium) ?? 0;
  }

  Future<void> updateHighScore(int currentScore, QuizDifficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (difficulty == QuizDifficulty.easy) {
      if (currentScore > highScoreEasy.value) {
        highScoreEasy.value = currentScore;
        await prefs.setInt(_keyEasy, currentScore);
      }
    } else {
      if (currentScore > highScoreMedium.value) {
        highScoreMedium.value = currentScore;
        await prefs.setInt(_keyMedium, currentScore);
      }
    }
  }

  ValueNotifier<int> getNotifierFor(QuizDifficulty difficulty) {
    return difficulty == QuizDifficulty.easy ? highScoreEasy : highScoreMedium;
  }
}