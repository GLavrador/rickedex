import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/theme/app_typography.dart';
import 'feed_go_button.dart';

class FeedSection extends StatelessWidget {
  const FeedSection({
    super.key,
    required this.title,
    required this.preview,
    required this.onTap,
  });

  final String title;
  final Widget preview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.answer(context).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: 6),

          Container(
            width: 48,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.primaryColorLight,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: preview),
              const SizedBox(width: 12),
              FeedGoButton(onTap: onTap),
            ],
          ),
        ],
      ),
    );
  }
}
