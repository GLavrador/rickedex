import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/feed/feed_skeleton_stack.dart';
import 'package:rick_morty_app/components/navigation/side_bar_component.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/feed/feed_section.dart';
import 'package:rick_morty_app/components/feed/feed_image_stack.dart';
import 'package:rick_morty_app/components/feed/feed_text_stack.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/pages/details_page.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/theme/app_images.dart';

class MainFeedPage extends StatelessWidget {
  const MainFeedPage({super.key});
  static const routeId = '/';

  @override
  Widget build(BuildContext context) {
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
              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: const Text(
                  'No connection',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final data = snap.data ?? <Character>[];
            if (data.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: const Text(
                  'No data',
                  style: TextStyle(color: Colors.white),
                ),
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
                  DetailsPage.routeId,
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
        previewBuilder: (ctx) => const FeedTextStack(
          items: ['Earth', 'Citadel', 'Gazorp', 'Gromflom'],
        ),
      ),

      _SectionConfig(
        title: 'Favorites',
        routeName: '/favorites',
        previewBuilder: (ctx) => const FeedTextStack(
          items: ['Saved', 'Ricks', 'Mortys', 'Other'],
        ),
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
