import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/quiz_types.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class LeaderboardHeader extends StatelessWidget {
  const LeaderboardHeader({
    super.key,
    required this.difficulty,
  });

  final QuizDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        children: [
          Text(
            "TOP 20 PLAYERS",
            style: TextStyle(
              color: AppColors.primaryColorLight,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              difficulty.name.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}