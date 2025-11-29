import 'package:flutter/foundation.dart';
import 'package:rick_morty_app/models/app_user.dart';
import 'package:rick_morty_app/models/quiz_types.dart';
import 'package:rick_morty_app/services/leaderboard_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizService {
  QuizService._();
  static final QuizService instance = QuizService._();

  final ValueNotifier<int> highScoreEasy = ValueNotifier(0);
  final ValueNotifier<int> highScoreMedium = ValueNotifier(0);
  final ValueNotifier<int> highScoreHard = ValueNotifier(0);

  static const _keyEasy = 'quiz_high_score_easy';
  static const _keyMedium = 'quiz_high_score_medium';
  static const _keyHard = 'quiz_high_score_hard';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    highScoreEasy.value = prefs.getInt(_keyEasy) ?? 0;
    highScoreMedium.value = prefs.getInt(_keyMedium) ?? 0;
    highScoreHard.value = prefs.getInt(_keyHard) ?? 0;
  }

  Future<void> resetLocalScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEasy);
    await prefs.remove(_keyMedium);
    await prefs.remove(_keyHard);
    
    highScoreEasy.value = 0;
    highScoreMedium.value = 0;
    highScoreHard.value = 0;
  }

  Future<void> syncWithCloud(AppUser cloudUser) async {
    final prefs = await SharedPreferences.getInstance();

    Future<void> syncScore(String key, int localVal, int cloudVal, ValueNotifier<int> notifier, QuizDifficulty diff) async {
      if (cloudVal > localVal) {
        await prefs.setInt(key, cloudVal);
        notifier.value = cloudVal;
      } else if (localVal > cloudVal) {
        LeaderboardService.instance.updateCloudScore(localVal, diff);
      }
    }

    await syncScore(_keyEasy, highScoreEasy.value, cloudUser.highScoreEasy, highScoreEasy, QuizDifficulty.easy);
    await syncScore(_keyMedium, highScoreMedium.value, cloudUser.highScoreMedium, highScoreMedium, QuizDifficulty.medium);
    await syncScore(_keyHard, highScoreHard.value, cloudUser.highScoreHard, highScoreHard, QuizDifficulty.hard);
  }

  Future<void> updateHighScore(int currentScore, QuizDifficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (difficulty == QuizDifficulty.easy) {
      if (currentScore > highScoreEasy.value) {
        highScoreEasy.value = currentScore;
        await prefs.setInt(_keyEasy, currentScore);
        LeaderboardService.instance.updateCloudScore(currentScore, difficulty);
      }
    } else if (difficulty == QuizDifficulty.medium) {
      if (currentScore > highScoreMedium.value) {
        highScoreMedium.value = currentScore;
        await prefs.setInt(_keyMedium, currentScore);
        LeaderboardService.instance.updateCloudScore(currentScore, difficulty);
      }
    } else {
      if (currentScore > highScoreHard.value) {
        highScoreHard.value = currentScore;
        await prefs.setInt(_keyHard, currentScore);
        LeaderboardService.instance.updateCloudScore(currentScore, difficulty);
      }
    }
  }

  ValueNotifier<int> getNotifierFor(QuizDifficulty difficulty) {
    switch (difficulty) {
      case QuizDifficulty.easy:
        return highScoreEasy;
      case QuizDifficulty.medium:
        return highScoreMedium;
      case QuizDifficulty.hard:
        return highScoreHard;
    }
  }
}