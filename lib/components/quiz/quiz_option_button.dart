import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class QuizOptionButton extends StatelessWidget {
  const QuizOptionButton({
    super.key,
    required this.text,
    required this.showAnswer,
    required this.isCorrect,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool showAnswer;
  final bool isCorrect;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color bgColor = AppColors.primaryColorDark;
    Color borderColor = Colors.transparent;
    Color textColor = Colors.white;

    if (showAnswer) {

      if (isCorrect) {
        bgColor = Colors.green.withValues(alpha: 0.2);
        borderColor = Colors.greenAccent;
        textColor = Colors.greenAccent;

      } else if (isSelected) {
        bgColor = Colors.red.withValues(alpha: 0.2);
        borderColor = Colors.redAccent;
        textColor = Colors.redAccent;

      } else {
        
        bgColor = AppColors.primaryColorDark.withValues(alpha: 0.5);
        textColor = Colors.white.withValues(alpha: 0.3);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor == Colors.transparent 
                  ? Colors.white.withValues(alpha: 0.1) 
                  : borderColor,
              width: 1.5,
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}