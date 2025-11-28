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

              if (options.length > 4) 
                _buildGridLayout()
              else 
                ...options.map((opt) => _buildOptionBtn(opt)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridLayout() {
    final List<Widget> gridRows = [];

    for (int i = 0; i < options.length; i += 2) {
      final leftOption = options[i];
      final rightOption = (i + 1 < options.length) ? options[i + 1] : null;

      gridRows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildOptionBtn(leftOption),
              ),
              if (rightOption != null) ...[
                const SizedBox(width: 12), 
                Expanded(
                  child: _buildOptionBtn(rightOption),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Column(
      children: gridRows,
    );
  }

  Widget _buildOptionBtn(String text) {
    return QuizOptionButton(
      text: text,
      showAnswer: answered,
      isCorrect: text == correctAnswerText,
      isSelected: text == selectedOption,
      onTap: () => onOptionSelected(text),
    );
  }
}