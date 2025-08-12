import 'package:flutter/material.dart';
import 'package:rick_morty_app/pages/episodes_page.dart';
import 'package:rick_morty_app/pages/home_page.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/theme/app_images.dart';

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
    // se ainda não tiver LocationsPage, usa a string e registra depois no onGenerateRoute
    const String locationsRoute = '/locations';

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
                      selected: _isRoute(context, locationsRoute),
                      onTap: () => _goToNamed(context, locationsRoute),
                    ),
                    ListTile(
                      leading: const Icon(Icons.movie_outlined),
                      title: const Text('Episodes'),
                      dense: true,
                      selected: _isRoute(context, EpisodesPage.routeId),
                      onTap: () => _goToNamed(context, EpisodesPage.routeId),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'v1.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white.withValues(alpha: 0.6),
                      ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
