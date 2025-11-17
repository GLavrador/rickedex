import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class FeedImageStack extends StatelessWidget {
  const FeedImageStack({
    super.key,
    required this.urls,
    required this.ids,
    required this.onTap,
  });

  final List<String> urls;
  final List<int> ids;
  final void Function(int id) onTap;

  @override
  Widget build(BuildContext context) {
    final list = urls.take(4).toList();
    final idList = ids.take(4).toList();

    const double size = 100;
    const double overlap = 75;

    return SizedBox(
      width: size + (list.length - 1) * overlap,
      height: size,
      child: Stack(
        children: List.generate(list.length, (i) {
          final highlight = i == list.length - 1;

          return Positioned(
            left: i * overlap,
            child: GestureDetector(
              onTap: () => onTap(idList[i]),
              child: _buildCard(list[i], highlight),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCard(String url, bool highlight) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight ? AppColors.primaryColorLight : Colors.transparent,
          width: 2,
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(url),
        ),
      ),
    );
  }
}
