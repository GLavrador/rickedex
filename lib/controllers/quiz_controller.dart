import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rick_morty_app/models/quiz_types.dart';
import 'package:rick_morty_app/services/quiz_service.dart';
import 'package:rick_morty_app/utils/quiz_generator.dart';

enum QuizGameState { loading, playing, showingResult, error }

class QuizGameController extends ChangeNotifier {
  QuizGameState state = QuizGameState.loading;
  QuizDifficulty difficulty = QuizDifficulty.easy;
  QuizRound? currentRound;
  int currentScore = 0;
  
  bool answered = false;
  String? selectedOption;
  bool isRoundSuccess = false;

  final List<QuizRound> _roundBuffer = [];
  bool _isBufferLoading = false;
  static const int _bufferTargetSize = 3;
  Timer? _transitionTimer;

  QuizGameController() {
    _init();
  }

  @override
  void dispose() {
    _transitionTimer?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    state = QuizGameState.loading;
    notifyListeners();
    
    await _replenishBuffer();
    
    if (_roundBuffer.isNotEmpty) {
      _nextRound();
    } else {
      state = QuizGameState.error;
      notifyListeners();
      _transitionTimer = Timer(const Duration(seconds: 3), _init);
    }
  }

  void handleAnswer(String answer) {
    if (answered) return;

    answered = true;
    selectedOption = answer;
    isRoundSuccess = (answer == currentRound!.correctAnswer);
    state = QuizGameState.showingResult;

    if (isRoundSuccess) {
      currentScore++;
      QuizService.instance.updateHighScore(currentScore, difficulty);
      _transitionTimer = Timer(const Duration(milliseconds: 1000), _nextRound);
    } else {
      _transitionTimer = Timer(const Duration(milliseconds: 2000), () {
        currentScore = 0; 
        _nextRound();
      });
    }
    
    notifyListeners();
  }

  void changeDifficulty(QuizDifficulty newDiff) {
    if (difficulty == newDiff) return;
    
    difficulty = newDiff;
    currentScore = 0;
    _roundBuffer.clear(); 
    _transitionTimer?.cancel(); 
    _init(); 
  }

  void retry() {
    _init();
  }

  void _nextRound() {
    if (_roundBuffer.isEmpty) {
      _init();
      return;
    }

    currentRound = _roundBuffer.removeAt(0);
    answered = false;
    selectedOption = null;
    state = QuizGameState.playing;
    
    notifyListeners();
    
    _replenishBuffer();
  }

  Future<void> _replenishBuffer() async {
    if (_isBufferLoading) return;
    if (_roundBuffer.length >= _bufferTargetSize) return;

    _isBufferLoading = true;

    try {
      while (_roundBuffer.length < _bufferTargetSize) {
        final round = await QuizGenerator.generateRound(difficulty);
        _roundBuffer.add(round);
      }
    } catch (e) {
      debugPrint("Buffer error: $e");
    } finally {
      _isBufferLoading = false;
    }
  }
}
