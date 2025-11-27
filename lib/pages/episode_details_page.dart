import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/detailed_cards/detailed_episode_card.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/episode.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/pages/character_details_page.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/utils/id_from_url.dart';

class EpisodeDetailsPage extends StatefulWidget {
  static const routeId = '/episode_details';
  const EpisodeDetailsPage({super.key, required this.episodeId});
  final int episodeId;

  @override
  State<EpisodeDetailsPage> createState() => _EpisodeDetailsPageState();
}

class _EpisodeDetailsPageState extends State<EpisodeDetailsPage> {
  late Future<Episode> _episodeFuture;
  late Future<List<Character>> _charsFuture;

  @override
  void initState() {
    super.initState();
    _episodeFuture = Repository.getEpisodeDetails(widget.episodeId);
    _charsFuture = _loadChars();
  }

  Future<List<Character>> _loadChars() async {
    final loc = await _episodeFuture;
    final ids = loc.characters
        .map(idFromUrl).whereType<int>().toSet().toList();

    if (ids.isEmpty) return const <Character>[];

    final characters = await Repository.getCharactersByIds(ids);
    characters.sort((a, b) => a.name.compareTo(b.name));
    return characters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context, isSecondPage: true),
      backgroundColor: AppColors.backgroundColor,
      body: FutureBuilder<Episode>(
        future: _episodeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('An error occurred.', style: TextStyle(color: AppColors.white)),
            );
          }

          final ep = snapshot.data!;
          return FutureBuilder<List<Character>>(
            future: _charsFuture,
            builder: (context, cSnap) {
              if (cSnap.connectionState == ConnectionState.waiting && !cSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final chars = cSnap.data; // pode ser nulo enquanto carrega
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  DetailedEpisodeCard(
                    episode: ep,
                    characters: chars ?? const <Character>[],
                    onCharacterTap: (id) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          settings: const RouteSettings(name: CharacterDetailsPage.routeId),
                          builder: (_) => CharacterDetailsPage(characterId: id),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
