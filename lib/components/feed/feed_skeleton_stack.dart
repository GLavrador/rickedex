import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class FeedSkeletonStack extends StatefulWidget {
  const FeedSkeletonStack({super.key});

  @override
  State<FeedSkeletonStack> createState() => _FeedSkeletonStackState();
}

class _FeedSkeletonStackState extends State<FeedSkeletonStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.05, end: 0.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double size = 100;
    const double overlap = 70;
    const int count = 4;

    return SizedBox(
      width: size + (count - 1) * overlap,
      height: size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: List.generate(count, (i) {
              final shouldMaskPrevious = i != 0;

              return Positioned(
                left: i * overlap,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: _animation.value),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                      width: 1.5,
                    ),
                    boxShadow: [
                      if (shouldMaskPrevious)
                        BoxShadow(
                          color: AppColors.backgroundColor, 
                          spreadRadius: 1.0,
                          blurRadius: 0,
                        ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}