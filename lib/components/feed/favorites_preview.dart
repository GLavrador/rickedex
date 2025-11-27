import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/feed/feed_image_stack.dart';
import 'package:rick_morty_app/components/feed/feed_skeleton_stack.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/pages/character_details_page.dart';
import 'package:rick_morty_app/services/favorites_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class FavoritesPreview extends StatelessWidget {
  const FavoritesPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<int>>(
      valueListenable: FavoritesService.instance.favorites,
      builder: (context, favoritesSet, child) {
        
        if (favoritesSet.isEmpty) {
          return const _EmptyFavoritesCard();
        }

        List<int> idsToFetch = favoritesSet.toList();
        if (idsToFetch.length > 5) {
          idsToFetch.shuffle();
          idsToFetch = idsToFetch.take(5).toList();
        } else {
          idsToFetch.sort();
        }

        return FutureBuilder<List<Character>>(
          future: Repository.getCharactersByIds(idsToFetch),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const FeedSkeletonStack();
            }

            if (snap.hasError || !snap.hasData || snap.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text('Error loading favorites', style: TextStyle(color: Colors.white)),
              );
            }

            final chars = snap.data!;
            final urls = chars.map((e) => e.image).toList();
            final ids = chars.map((e) => e.id).toList();

            return FeedImageStack(
              imagePaths: urls,
              ids: ids,
              onTap: (id) {
                Navigator.pushNamed(
                  context,
                  CharacterDetailsPage.routeId,
                  arguments: id,
                );
              },
            );
          },
        );
      },
    );
  }
}

class _EmptyFavoritesCard extends StatelessWidget {
  const _EmptyFavoritesCard();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/characters'),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.primaryColorDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primaryColorLight,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.add_rounded,
            color: AppColors.white,
            size: 36,
          ),
        ),
      ),
    );
  }
}