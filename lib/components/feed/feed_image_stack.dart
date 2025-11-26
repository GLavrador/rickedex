import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class FeedImageStack extends StatelessWidget {
  const FeedImageStack({
    super.key,
    required this.imagePaths,
    required this.ids,
    required this.onTap,
    this.maxItems = 5,
  });

  final List<String> imagePaths;
  final List<int> ids;
  final void Function(int id) onTap;
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    final list = imagePaths.take(maxItems).toList();
    final idList = ids.take(maxItems).toList();

    const double size = 100;
    const double overlap = 70;

    final contentWidth = size + (list.length - 1) * overlap;

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent, 
            Colors.white,       
            Colors.white,      
            Colors.transparent, 
          ],
          stops: [0.0, 0.05, 0.95, 1.0], 
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: contentWidth,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
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
        ),
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
          onError: (exception, stackTrace) {
             debugPrint('Failed to load image ($path): $exception');
          },
        ),
      ),
    );
  }
}