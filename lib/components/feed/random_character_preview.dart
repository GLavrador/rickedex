import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/services/feed_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class RandomCharacterPreview extends StatelessWidget {
  const RandomCharacterPreview({super.key});

  Stream<int> _timerStream() {
    return Stream.periodic(const Duration(seconds: 3), (tick) => tick);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ValueListenableBuilder<List<Character>?>(
        valueListenable: FeedService.instance.randomCharacters,
        builder: (context, data, child) {
          
          if (data == null) {
            return _baseContainer(
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
            );
          }

          if (data.isEmpty) {
            return _clickableWrapper(
              context,
              child: _baseContainer(
                child: const Center(child: Icon(Icons.shuffle, color: Colors.white, size: 30)),
              ),
            );
          }

          return StreamBuilder<int>(
            stream: _timerStream(),
            builder: (context, timerSnapshot) {
              final tick = timerSnapshot.data ?? 0;
              final index = tick % data.length;
              final char = data[index];

              return _clickableWrapper(
                context,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _baseContainer(
                    key: ValueKey<int>(char.id),
                    imageProvider: NetworkImage(char.image),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _clickableWrapper(BuildContext context, {required Widget child}) {
    final borderRadius = BorderRadius.circular(14);
    
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: () => Navigator.of(context).pushNamed('/random'),
              highlightColor: Colors.white.withValues(alpha: 0.1),
              splashColor: Colors.white.withValues(alpha: 0.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _baseContainer({Key? key, Widget? child, ImageProvider? imageProvider}) {
    return Container(
      key: key,
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.primaryColorDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        image: imageProvider != null
            ? DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: child,
    );
  }
}