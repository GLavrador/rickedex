import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/navigation/side_bar_component.dart';
import 'package:rick_morty_app/components/quiz/quiz_difficulty_button.dart'; 
import 'package:rick_morty_app/components/quiz/quiz_game_content.dart';
import 'package:rick_morty_app/components/quiz/quiz_score_board.dart';
import 'package:rick_morty_app/models/quiz_types.dart';
import 'package:rick_morty_app/services/quiz_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/utils/quiz_generator.dart'; 

class QuizPage extends StatefulWidget {
  static const routeId = '/quiz';
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuizDifficulty _difficulty = QuizDifficulty.easy;
  bool _isLoading = true;
  QuizRound? _currentRound;
  int _currentScore = 0;
  
  bool _answered = false;
  String? _selectedOption;
  bool _isRoundSuccess = false;

  @override
  void initState() {
    super.initState();
    _startNewRound();
  }

  Future<void> _startNewRound() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _answered = false;
      _selectedOption = null;
    });

    try {
      final round = await QuizGenerator.generateRound(_difficulty);

      if (!mounted) return;
      setState(() {
        _currentRound = round;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) Future.delayed(const Duration(seconds: 1), _startNewRound);
    }
  }

  void _handleAnswer(String answer) {
    if (_answered) return; 

    final isCorrect = answer == _currentRound!.correctAnswer;

    setState(() {
      _answered = true;
      _selectedOption = answer;
      _isRoundSuccess = isCorrect;
    });

    if (isCorrect) {
      _currentScore++;
      QuizService.instance.updateHighScore(_currentScore, _difficulty);
      Timer(const Duration(milliseconds: 1500), _startNewRound);
    } else {
      Timer(const Duration(milliseconds: 2500), () {
        if (mounted) {
          setState(() => _currentScore = 0);
          _startNewRound();
        }
      });
    }
  }

  void _changeDifficulty(QuizDifficulty newDiff) {
    if (_difficulty == newDiff) return;
    setState(() {
      _difficulty = newDiff;
      _currentScore = 0;
      _startNewRound();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBarComponent(
        context,
        isMenuAndHome: true,
        actions: [
          QuizDifficultyButton(
            currentDifficulty: _difficulty,
            onDifficultyChanged: _changeDifficulty,
          ),
        ],
      ),
      drawer: const SideBarComponent(),
      body: SafeArea(
        child: Column(
          children: [
            QuizScoreBoard(
              currentScore: _currentScore,
              difficulty: _difficulty,
            ),

            Expanded(
              child: _isLoading || _currentRound == null
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : QuizGameContent(
                      subject: _currentRound!.subject,
                      questionText: _currentRound!.question,
                      options: _currentRound!.options,
                      correctAnswerText: _currentRound!.correctAnswer,
                      answered: _answered,
                      selectedOption: _selectedOption,
                      isCorrectAnswer: _isRoundSuccess,
                      onOptionSelected: _handleAnswer,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}