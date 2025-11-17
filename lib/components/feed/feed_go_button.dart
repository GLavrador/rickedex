import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class FeedGoButton extends StatelessWidget {
  const FeedGoButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primaryColorLight.withValues(alpha: .99),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.white,
          size: 18,
        ),
      ),
    );
  }
}
