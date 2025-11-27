import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class FeedTextStack extends StatelessWidget {
  const FeedTextStack({
    super.key,
    required this.items,
  });

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final list = items.take(4).toList();

    const double size = 88;
    const double overlap = 66;

    return SizedBox(
      width: size + (list.length - 1) * overlap,
      height: size,
      child: Stack(
        children: List.generate(list.length, (i) {
          final highlight = i == list.length - 1;
          final label = list[i];

          return Positioned(
            left: i * overlap,
            child: _card(label, highlight),
          );
        }),
      ),
    );
  }

  Widget _card(String label, bool highlight) {
    return Container(
      width: 88,
      height: 88,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primaryColorLight
            : AppColors.primaryColorDark,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: highlight ? 12 : 10,
            offset: const Offset(0, 4),
          ),
        ],

        border: Border.all(
          color: highlight
              ? Colors.white.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.10),
          width: highlight ? 1.4 : 1,
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
