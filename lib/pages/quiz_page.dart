import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/navigation/side_bar_component.dart';
import 'package:rick_morty_app/components/quiz/quiz_game_content.dart';
import 'package:rick_morty_app/components/quiz/quiz_score_board.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/services/quiz_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class QuizPage extends StatefulWidget {
  static const routeId = '/quiz';
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool _isLoading = true;
  List<Character> _options = [];
  Character? _correctCharacter;
  int _currentScore = 0;
  
  bool _answered = false;
  int? _selectedId;
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
      _selectedId = null;
    });

    try {
      final chars = await Repository.getRandomCharacters(4);
      if (chars.length < 4) throw Exception("Not enough chars");

      if (!mounted) return;

      setState(() {
        _options = chars;
        _correctCharacter = chars[Random().nextInt(chars.length)];
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) Future.delayed(const Duration(seconds: 1), _startNewRound);
    }
  }

  void _handleAnswer(int charId) {
    if (_answered) return; 

    final isCorrect = charId == _correctCharacter!.id;

    setState(() {
      _answered = true;
      _selectedId = charId;
      _isRoundSuccess = isCorrect;
    });

    if (isCorrect) {
      _currentScore++;
      QuizService.instance.updateHighScore(_currentScore);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBarComponent(context, isMenuAndHome: true),
      drawer: const SideBarComponent(),
      body: SafeArea(
        child: Column(
          children: [
            QuizScoreBoard(currentScore: _currentScore),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : QuizGameContent(
                      correctCharacter: _correctCharacter!,
                      options: _options,
                      answered: _answered,
                      selectedId: _selectedId,
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