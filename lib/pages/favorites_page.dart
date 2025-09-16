import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/buttons/clear_favorite_button.dart';
import 'package:rick_morty_app/components/grids/favorite_character_grid.dart';
import 'package:rick_morty_app/components/navigation/page_flag.dart';
import 'package:rick_morty_app/components/navigation/side_bar_component.dart';
import 'package:rick_morty_app/services/favorites_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/character.dart';

class FavoritesPage extends StatefulWidget {
  static const routeId = '/favorites';
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Future<List<Character>>? _future;

  @override
  void initState() {
    super.initState();
    // carrega inicial e re-carrega quando favoritos mudarem
    _load();
    FavoritesService.instance.favorites.addListener(_load);
  }

  @override
  void dispose() {
    FavoritesService.instance.favorites.removeListener(_load);
    super.dispose();
  }

  void _load() {
    final ids = FavoritesService.instance.favorites.value.toList()..sort();
    setState(() {
      _future = Repository.getCharactersByIds(ids);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context),
      drawer: const SideBarComponent(),
      backgroundColor: AppColors.backgroundColor,
      body: FutureBuilder<List<Character>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data ?? const <Character>[];
          if (data.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'You have yet to mark favorite characters.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: PageFlag('Favorites'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: const ClearFavoritesButton(),
                ),
              ),
              Expanded(
                child: CharacterGridView(characters: data),
              ),
            ],
          );
        },
      ),
    );
  }
}
