import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/quiz/quiz_game_content.dart';
import 'package:rick_morty_app/controllers/quiz_controller.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class QuizView extends StatelessWidget {
  const QuizView({super.key, required this.controller});

  final QuizGameController controller;

  @override
  Widget build(BuildContext context) {
    switch (controller.state) {
      case QuizGameState.loading:
        return const Center(child: CircularProgressIndicator(color: Colors.white));
      
      case QuizGameState.error:
        return _ErrorView(onRetry: controller.retry);

      case QuizGameState.playing:
      case QuizGameState.showingResult:
        if (controller.currentRound == null) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        return QuizGameContent(
          subject: controller.currentRound!.subject,
          questionText: controller.currentRound!.question,
          options: controller.currentRound!.options,
          correctAnswerText: controller.currentRound!.correctAnswer,
          answered: controller.answered,
          selectedOption: controller.selectedOption,
          isCorrectAnswer: controller.isRoundSuccess,
          onOptionSelected: controller.handleAnswer,
        );
    }
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Failed to load data",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: Text(
              "Retry",
              style: TextStyle(color: AppColors.primaryColorLight),
            ),
          )
        ],
      ),
    );
  }
}