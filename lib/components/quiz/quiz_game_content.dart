import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/quiz/quiz_option_button.dart';
import 'package:rick_morty_app/models/character.dart';

class QuizGameContent extends StatelessWidget {
  const QuizGameContent({
    super.key,
    required this.correctCharacter,
    required this.options,
    required this.answered,
    required this.selectedId,
    required this.onOptionSelected,
    required this.isCorrectAnswer,
  });

  final Character correctCharacter;
  final List<Character> options;
  final bool answered;
  final int? selectedId;
  final ValueChanged<int> onOptionSelected;
  final bool isCorrectAnswer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Who is this character?",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: answered
                        ? (isCorrectAnswer ? Colors.greenAccent : Colors.redAccent)
                        : Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(correctCharacter.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              ...options.map((char) {
                return QuizOptionButton(
                  character: char,
                  showAnswer: answered,
                  isCorrect: char.id == correctCharacter.id,
                  isSelected: char.id == selectedId,
                  onTap: () => onOptionSelected(char.id),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}