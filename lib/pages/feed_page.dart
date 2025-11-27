import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/feed/feed_skeleton_stack.dart';
import 'package:rick_morty_app/components/navigation/side_bar_component.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/feed/feed_section.dart';
import 'package:rick_morty_app/components/feed/feed_image_stack.dart';
import 'package:rick_morty_app/components/feed/feed_text_stack.dart'; 
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/pages/character_details_page.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/theme/app_images.dart';
import 'package:rick_morty_app/services/favorites_service.dart';

class MainFeedPage extends StatelessWidget {
  const MainFeedPage({super.key});
  static const routeId = '/';

  @override
  Widget build(BuildContext context) {
    
    final locationDimensions = [
      'unknown',
      'Fantasy Dimension',
      'Replacement Dimension',
      'Dimension C-137',
    ];

    final sections = <_SectionConfig>[
      _SectionConfig(
        title: 'Characters',
        routeName: '/characters',
        previewBuilder: (ctx) => FutureBuilder<List<Character>>(
          future: Repository.getRandomCharacters(5),
          builder: (c, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 110,
                height: 100,
                child: Center(child: FeedSkeletonStack()),
              );
            }

            if (snap.hasError) {
              return const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text('No connection', style: TextStyle(color: Colors.white)),
              );
            }

            final data = snap.data ?? <Character>[];
            if (data.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text('No data', style: TextStyle(color: Colors.white)),
              );
            }

            final urls = data.map((e) => e.image).toList();
            final ids  = data.map((e) => e.id).toList();

            return FeedImageStack(
              imagePaths: urls,
              ids: ids,
              onTap: (id) {
                Navigator.pushNamed(
                  ctx,
                  CharacterDetailsPage.routeId,
                  arguments: id,
                );
              },
            );
          },
        ),
      ),

      _SectionConfig(
        title: 'Episodes',
        routeName: '/episodes',
        previewBuilder: (ctx) => FeedImageStack(
          imagePaths: const [
            AppImages.s1,
            AppImages.s2,
            AppImages.s3,
            AppImages.s4,
            AppImages.s5,
          ],
          ids: const [1, 2, 3, 4, 5],
          onTap: (seasonId) {
            Navigator.of(ctx).pushNamed('/episodes', arguments: seasonId);
          },
        ),
      ),

      _SectionConfig(
        title: 'Locations',
        routeName: '/locations',
        previewBuilder: (ctx) => FeedImageStack(
          imagePaths: const [
            AppImages.l1,
            AppImages.l2,
            AppImages.l3,
            AppImages.l4,
          ],

          ids: const [0, 1, 2, 3],
          onTap: (index) {
            final dimensionName = locationDimensions[index];

            Navigator.of(ctx).pushNamed('/locations', arguments: dimensionName);
          },
        ),
      ),

      _SectionConfig(
        title: 'Favorites',
        routeName: '/favorites',
        previewBuilder: (ctx) {
          return ValueListenableBuilder<Set<int>>(
            valueListenable: FavoritesService.instance.favorites,
            builder: (context, favoritesSet, child) {
              
              if (favoritesSet.isEmpty) {
                return const FeedTextStack(
                  items: ['Mark', 'Your', 'Best', 'Chars'],
                );
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
                    return const FeedTextStack(items: ['Error', 'Loading', 'Favs']);
                  }

                  final chars = snap.data!;
                  final urls = chars.map((e) => e.image).toList();
                  final ids = chars.map((e) => e.id).toList();

                  return FeedImageStack(
                    imagePaths: urls,
                    ids: ids,
                    onTap: (id) {
                      Navigator.pushNamed(
                        ctx,
                        CharacterDetailsPage.routeId,
                        arguments: id,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),

      _SectionConfig(
        title: 'Random',
        routeName: '/random',
        previewBuilder: (ctx) => const FeedTextStack(
          items: ['Try', 'Shuffle', 'Lucky', 'Surprise'],
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBarComponent(context, isSecondPage: false),
      drawer: const SideBarComponent(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 6, bottom: 24),
                itemCount: sections.length * 2 - 1,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  if (i.isOdd) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(thickness: 1, color: Color(0xFF8A8AE6), height: 18, endIndent: 0),
                    );
                  }
                  final idx = i ~/ 2;
                  final s = sections[idx];
                  return FeedSection(
                    title: s.title,
                    preview: s.previewBuilder(context),
                    onTap: () => Navigator.of(context).pushNamed(s.routeName),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionConfig {
  final String title;
  final String routeName;
  final WidgetBuilder previewBuilder;
  const _SectionConfig({
    required this.title,
    required this.routeName,
    required this.previewBuilder,
  });
}
