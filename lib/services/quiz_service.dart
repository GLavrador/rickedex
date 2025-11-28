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

  Future<void> syncWithCloud(AppUser cloudUser) async {
    final prefs = await SharedPreferences.getInstance();

    int localEasy = prefs.getInt(_keyEasy) ?? 0;
    if (cloudUser.highScoreEasy > localEasy) {
      localEasy = cloudUser.highScoreEasy;
      await prefs.setInt(_keyEasy, localEasy);
      highScoreEasy.value = localEasy;
    } else if (localEasy > cloudUser.highScoreEasy) {
      LeaderboardService.instance.updateCloudScore(localEasy, QuizDifficulty.easy);
    }

    int localMedium = prefs.getInt(_keyMedium) ?? 0;
    if (cloudUser.highScoreMedium > localMedium) {
      localMedium = cloudUser.highScoreMedium;
      await prefs.setInt(_keyMedium, localMedium);
      highScoreMedium.value = localMedium;
    } else if (localMedium > cloudUser.highScoreMedium) {
      LeaderboardService.instance.updateCloudScore(localMedium, QuizDifficulty.medium);
    }

    int localHard = prefs.getInt(_keyHard) ?? 0;
    if (cloudUser.highScoreHard > localHard) {
      localHard = cloudUser.highScoreHard;
      await prefs.setInt(_keyHard, localHard);
      highScoreHard.value = localHard;
    } else if (localHard > cloudUser.highScoreHard) {
      LeaderboardService.instance.updateCloudScore(localHard, QuizDifficulty.hard);
    }
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