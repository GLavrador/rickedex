import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/navigation/side_bar_component.dart';
import 'package:rick_morty_app/components/quiz/quiz_difficulty_button.dart';
import 'package:rick_morty_app/components/quiz/quiz_game_content.dart';
import 'package:rick_morty_app/components/quiz/quiz_score_board.dart';
import 'package:rick_morty_app/controllers/quiz_controller.dart';
import 'package:rick_morty_app/theme/app_colors.dart'; 

class QuizPage extends StatefulWidget {
  static const routeId = '/quiz';
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  late final QuizGameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QuizGameController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: appBarComponent(
            context,
            isMenuAndHome: true,
            actions: [
              QuizDifficultyButton(
                currentDifficulty: _controller.difficulty,
                onDifficultyChanged: _controller.changeDifficulty,
              ),
            ],
          ),
          drawer: const SideBarComponent(),
          body: SafeArea(
            child: Column(
              children: [
                QuizScoreBoard(
                  currentScore: _controller.currentScore,
                  difficulty: _controller.difficulty,
                ),
                Expanded(
                  child: _buildBodyContent(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodyContent() {
    switch (_controller.state) {
      case QuizGameState.loading:
        return const Center(child: CircularProgressIndicator(color: Colors.white));
      
      case QuizGameState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Failed to load data", style: TextStyle(color: Colors.white)),
              TextButton(
                onPressed: _controller.retry,
                child: const Text("Retry"),
              )
            ],
          ),
        );

      case QuizGameState.playing:
      case QuizGameState.showingResult:
        if (_controller.currentRound == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return QuizGameContent(
          subject: _controller.currentRound!.subject,
          questionText: _controller.currentRound!.question,
          options: _controller.currentRound!.options,
          correctAnswerText: _controller.currentRound!.correctAnswer,
          answered: _controller.answered,
          selectedOption: _controller.selectedOption,
          isCorrectAnswer: _controller.isRoundSuccess,
          
          onOptionSelected: _controller.handleAnswer,
        );
    }
  }
}