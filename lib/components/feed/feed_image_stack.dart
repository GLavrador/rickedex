import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class FeedImageStack extends StatelessWidget {
  const FeedImageStack({
    super.key,
    required this.imagePaths,
    required this.ids,
    required this.onTap,
  });

  final List<String> imagePaths;
  final List<int> ids;
  final void Function(int id) onTap;

  @override
  Widget build(BuildContext context) {
    final list = imagePaths.take(4).toList();
    final idList = ids.take(4).toList();

    const double size = 100;
    const double overlap = 70;

    return SizedBox(
      width: size + (list.length - 1) * overlap,
      height: size,
      child: Stack(
        children: List.generate(list.length, (i) {
          final highlight = i == list.length - 1;
          final shouldMaskPrevious = i != 0;

          return Positioned(
            left: i * overlap,
            child: GestureDetector(
              onTap: () => onTap(idList[i]),
              child: _buildCard(list[i], highlight, shouldMaskPrevious),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCard(String path, bool highlight, bool shouldMaskPrevious) {
    final imageProvider = path.startsWith('http')
        ? NetworkImage(path)
        : AssetImage(path) as ImageProvider;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.primaryColorDark, 
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight ? AppColors.primaryColorLight : Colors.white,
          width: highlight ? 3 : 1.5,
        ),
        boxShadow: [
          if (shouldMaskPrevious)
            BoxShadow(
              color: AppColors.backgroundColor,
              spreadRadius: 1.0,
              blurRadius: 0,
            ),
        ],
        image: DecorationImage(
          fit: BoxFit.cover,
          image: imageProvider,
        ),
      ),
    );
  }
}