import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/character.dart';
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
      child: FutureBuilder<List<Character>>(
        future: Repository.getRandomCharacters(10),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _baseContainer(
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
            );
          }

          final characters = snapshot.data ?? [];

          if (snapshot.hasError || characters.isEmpty) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('/random'),
              child: _baseContainer(
                child: const Center(child: Icon(Icons.shuffle, color: Colors.white, size: 30)),
              ),
            );
          }

          return StreamBuilder<int>(
            stream: _timerStream(),
            builder: (context, timerSnapshot) {
              final tick = timerSnapshot.data ?? 0;
              final index = tick % characters.length;
              final char = characters[index];

              return GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/random'),
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