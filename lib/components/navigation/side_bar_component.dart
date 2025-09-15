import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rick_morty_app/components/organization/section_label.dart';
import 'package:rick_morty_app/pages/episodes_page.dart';
import 'package:rick_morty_app/pages/favorites_page.dart';
import 'package:rick_morty_app/pages/home_page.dart';
import 'package:rick_morty_app/pages/locations_page.dart';
import 'package:rick_morty_app/pages/random_page.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/theme/app_images.dart';
import 'package:rick_morty_app/services/favorites_service.dart';

class SideBarComponent extends StatelessWidget {
  const SideBarComponent({super.key});

  bool _isRoute(BuildContext context, String route) =>
      ModalRoute.of(context)?.settings.name == route;

  void _goToNamed(BuildContext context, String routeName) {
    Navigator.of(context).pop(); // fecha o Drawer
    if (!_isRoute(context, routeName)) {
      Navigator.of(context).pushReplacementNamed(routeName);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: AppColors.appBarColor,
      child: SafeArea(
        child: ListTileTheme(
          iconColor: AppColors.white,
          textColor: AppColors.white,
          selectedColor: AppColors.white,
          selectedTileColor: AppColors.primaryColorDark.withValues(alpha: 0.18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                decoration: BoxDecoration(
                  color: AppColors.appBarColor,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.logo,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Rick & Morty',
                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.5,
                        height: 1.0,                 
                        letterSpacing: 14.5 * 0.165, 
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [

                    const SectionLabel('Pages'),
                    
                    ListTile(
                      leading: const Icon(Icons.people_alt_outlined),
                      title: const Text('Characters'),
                      dense: true,
                      selected: _isRoute(context, HomePage.routeId),
                      onTap: () => _goToNamed(context, HomePage.routeId),
                    ),
                    ListTile(
                      leading: const Icon(Icons.public_outlined),
                      title: const Text('Locations'),
                      dense: true,
                      selected: _isRoute(context, LocationsPage.routeId),
                      onTap: () => _goToNamed(context, LocationsPage.routeId),
                    ),
                    ListTile(
                      leading: const Icon(Icons.movie_outlined),
                      title: const Text('Episodes'),
                      dense: true,
                      selected: _isRoute(context, EpisodesPage.routeId),
                      onTap: () => _goToNamed(context, EpisodesPage.routeId),
                    ),

                    const SectionLabel('Utilities'),
                    
                    ListTile(
                      leading: const Icon(Icons.favorite_border),
                      iconColor: AppColors.white,
                      title: const Text('Favorites'),
                      dense: true,
                      trailing: const _FavoritesBadge(),
                      selected: _isRoute(context, FavoritesPage.routeId),
                      onTap: () => _goToNamed(context, FavoritesPage.routeId),
                    ),
                    ListTile(
                      leading: const Icon(Icons.casino_outlined),
                      title: const Text('Random'),
                      dense: true,
                      selected: _isRoute(context, RandomPage.routeId),
                      onTap: () => _goToNamed(context, RandomPage.routeId),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final version = snapshot.hasData ? snapshot.data!.version : '...';
                    return Text(
                      'v$version',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.white.withValues(alpha: 0.6),
                          ),
                      textAlign: TextAlign.right,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// se um dia for transformar em público/reutilizável, mover e colocar key
class _FavoritesBadge extends StatelessWidget {
  const _FavoritesBadge();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<int>>(
      valueListenable: FavoritesService.instance.favorites,
      builder: (context, favs, _) {
        final count = favs.length;
        if (count == 0) return const SizedBox.shrink();
        final label = count > 99 ? '99+' : '$count';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primaryColorDark.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}