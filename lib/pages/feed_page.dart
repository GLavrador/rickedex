import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/navigation/side_bar_component.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/feed/feed_section.dart';
import 'package:rick_morty_app/components/feed/feed_image_stack.dart';
import 'package:rick_morty_app/components/feed/characters_preview.dart';
import 'package:rick_morty_app/components/feed/favorites_preview.dart';
import 'package:rick_morty_app/components/feed/random_character_preview.dart';
import 'package:rick_morty_app/data/repository.dart'; 
import 'package:rick_morty_app/models/character.dart'; 
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/theme/app_images.dart';

class MainFeedPage extends StatefulWidget {
  const MainFeedPage({super.key});
  static const routeId = '/';

  @override
  State<MainFeedPage> createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {

  static Future<List<Character>>? _cachedCharactersFuture;

  @override
  void initState() {
    super.initState();
 
    if (_cachedCharactersFuture == null) {
      _loadCharacters();
    }
  }

  void _loadCharacters() {
    _cachedCharactersFuture = Repository.getRandomCharacters(5);
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (mounted) {
      setState(() {
        _loadCharacters();
      });
    }
  }

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
        previewBuilder: (ctx) => CharactersPreview(
          characterFuture: _cachedCharactersFuture!,
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
          labels: const ['S1', 'S2', 'S3', 'S4', 'S5'],
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
          labels: ['Unknown','Fantasy','Replacement','C-137',],
          onTap: (index) {
            final dimensionName = locationDimensions[index];

            Navigator.of(ctx).pushNamed('/locations', arguments: dimensionName);
          },
        ),
      ),

      _SectionConfig(
        title: 'Favorites',
        routeName: '/favorites',
        previewBuilder: (ctx) => const FavoritesPreview(),
      ),

      _SectionConfig(
        title: 'Random',
        routeName: '/random',
        previewBuilder: (ctx) => const RandomCharacterPreview(),
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
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.white,
                backgroundColor: AppColors.primaryColorDark,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
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
