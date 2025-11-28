import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/quiz_types.dart';
import 'package:rick_morty_app/services/quiz_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class QuizScoreBoard extends StatelessWidget {
  const QuizScoreBoard({
    super.key,
    required this.currentScore,
    required this.difficulty,
  });

  final int currentScore;
  final QuizDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final labelDiff = difficulty == QuizDifficulty.easy ? '(Easy)' : '(Medium)';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildScoreColumn(
            label: 'SCORE',
            value: '$currentScore',
            color: Colors.white,
          ),
          
          ValueListenableBuilder<int>(
            valueListenable: QuizService.instance.getNotifierFor(difficulty),
            builder: (context, best, _) {
              return _buildScoreColumn(
                label: 'BEST $labelDiff',
                value: '$best',
                color: Colors.white.withValues(alpha: 0.9),
                isRightAligned: true,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScoreColumn({
    required String label,
    required String value,
    required Color color,
    bool isRightAligned = false,
  }) {
    return Column(
      crossAxisAlignment:
          isRightAligned ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isRightAligned 
                ? Colors.white.withValues(alpha: 0.6) 
                : AppColors.primaryColorLight,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}