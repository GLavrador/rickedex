import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/leaderboard/leaderboard_user_card.dart';
import 'package:rick_morty_app/models/app_user.dart';
import 'package:rick_morty_app/models/quiz_types.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class LeaderboardList extends StatelessWidget {
  const LeaderboardList({
    super.key,
    required this.future,
    required this.currentDifficulty,
    required this.onRefresh,
  });

  final Future<List<AppUser>>? future;
  final QuizDifficulty currentDifficulty;
  final RefreshCallback onRefresh;

  int _getScoreForDifficulty(AppUser user) {
    switch (currentDifficulty) {
      case QuizDifficulty.easy: return user.highScoreEasy;
      case QuizDifficulty.medium: return user.highScoreMedium;
      case QuizDifficulty.hard: return user.highScoreHard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primaryColorLight,
      backgroundColor: AppColors.appBarColor,
      child: FutureBuilder<List<AppUser>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (snapshot.hasError) {
            return _buildMessage("Failed to load ranking");
          }

          final players = snapshot.data ?? [];

          if (players.isEmpty) {
            return _buildMessage("No records yet.");
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final user = players[index];
              final score = _getScoreForDifficulty(user);
              
              if (score == 0) return const SizedBox.shrink();

              return LeaderboardUserCard(
                user: user,
                rank: index + 1,
                score: score,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMessage(String msg) {
    return Center(
      child: Text(msg, style: const TextStyle(color: Colors.white)),
    );
  }
}