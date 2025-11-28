import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/quiz_types.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class QuizDifficultyButton extends StatelessWidget {
  const QuizDifficultyButton({
    super.key,
    required this.currentDifficulty,
    required this.onDifficultyChanged,
  });

  final QuizDifficulty currentDifficulty;
  final ValueChanged<QuizDifficulty> onDifficultyChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 6, right: 8),
        child: PopupMenuButton<QuizDifficulty>(
          icon: Icon(Icons.tune, color: AppColors.primaryColorLight),
          tooltip: 'Difficulty',
          initialValue: currentDifficulty,
          onSelected: onDifficultyChanged,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: QuizDifficulty.easy,
              child: Text('Easy (Names and species only)'),
            ),
            const PopupMenuItem(
              value: QuizDifficulty.medium,
              child: Text('Medium (Mixed questions)'),
            ),
            const PopupMenuItem(
              value: QuizDifficulty.hard,
              child: Text('Hard (Expert details)'),
            ),
          ],
        ),
      ),
    );
  }
}