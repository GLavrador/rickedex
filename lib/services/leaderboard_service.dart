import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rick_morty_app/models/app_user.dart';
import 'package:rick_morty_app/models/quiz_types.dart';
import 'package:rick_morty_app/services/auth_service.dart';

class LeaderboardService {
  LeaderboardService._();
  static final LeaderboardService instance = LeaderboardService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateCloudScore(int newScore, QuizDifficulty difficulty) async {
    final user = AuthService.instance.currentUser.value;

    if (user == null) return;

    String fieldToUpdate;
    int currentScore;

    switch (difficulty) {
      case QuizDifficulty.easy:
        fieldToUpdate = 'highScoreEasy';
        currentScore = user.highScoreEasy;
        break;
      case QuizDifficulty.medium:
        fieldToUpdate = 'highScoreMedium';
        currentScore = user.highScoreMedium;
        break;
      case QuizDifficulty.hard:
        fieldToUpdate = 'highScoreHard';
        currentScore = user.highScoreHard;
        break;
    }

    if (newScore > currentScore) {
      await _db.collection('users').doc(user.id).update({
        fieldToUpdate: newScore,
      });
      
      await AuthService.instance.init(); 
    }
  }

  Future<List<AppUser>> getTopPlayers(QuizDifficulty difficulty) async {
    String orderByField;
    switch (difficulty) {
      case QuizDifficulty.easy:
        orderByField = 'highScoreEasy';
        break;
      case QuizDifficulty.medium:
        orderByField = 'highScoreMedium';
        break;
      case QuizDifficulty.hard:
        orderByField = 'highScoreHard';
        break;
    }

    try {
      final query = await _db
          .collection('users')
          .orderBy(orderByField, descending: true)
          .limit(20) 
          .get();

      return query.docs.map((doc) => AppUser.fromMap(doc.data())).toList();
    } catch (e) {
      return [];
    }
  }
}