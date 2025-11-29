import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/quiz_types.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class LeaderboardFilterButton extends StatelessWidget {
  const LeaderboardFilterButton({
    super.key,
    required this.currentDifficulty,
    required this.onSelected,
  });

  final QuizDifficulty currentDifficulty;
  final ValueChanged<QuizDifficulty> onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 6, right: 8),
        child: PopupMenuButton<QuizDifficulty>(
          icon: Icon(Icons.filter_list, color: AppColors.primaryColorLight),
          tooltip: 'Ranking Filter',
          initialValue: currentDifficulty,
          onSelected: onSelected,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: QuizDifficulty.hard,
              child: Text('Hard'),
            ),
            const PopupMenuItem(
              value: QuizDifficulty.medium,
              child: Text('Medium'),
            ),
            const PopupMenuItem(
              value: QuizDifficulty.easy,
              child: Text('Easy'),
            ),
          ],
        ),
      ),
    );
  }
}