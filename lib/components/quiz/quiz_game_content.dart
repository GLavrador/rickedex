import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/quiz/quiz_option_button.dart';
import 'package:rick_morty_app/models/character.dart';

class QuizGameContent extends StatelessWidget {
  const QuizGameContent({
    super.key,
    required this.subject,
    required this.questionText, 
    required this.options, 
    required this.answered,
    required this.selectedOption,
    required this.onOptionSelected,
    required this.isCorrectAnswer,
    required this.correctAnswerText,
  });

  final Character subject;
  final String questionText;
  final List<String> options;
  final bool answered;
  final String? selectedOption;
  final ValueChanged<String> onOptionSelected;
  final bool isCorrectAnswer;
  final String correctAnswerText;

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
                questionText,
                textAlign: TextAlign.center,
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
                    image: NetworkImage(subject.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),

              ...options.map((opt) {
                return QuizOptionButton(
                  text: opt,
                  showAnswer: answered,
                  isCorrect: opt == correctAnswerText,
                  isSelected: opt == selectedOption,
                  onTap: () => onOptionSelected(opt),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}