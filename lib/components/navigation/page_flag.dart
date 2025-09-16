import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class PageFlag extends StatelessWidget {
  const PageFlag(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.white.withValues(alpha: 0.92),
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 1.0,
            letterSpacing: 16 * 0.08,
          ),
    );
  }
}
