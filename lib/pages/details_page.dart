import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/detailed_cards/detailed_character_card.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/utils/id_from_url.dart';
import 'package:rick_morty_app/pages/location_details_page.dart';
import 'package:rick_morty_app/pages/episode_details_page.dart';

class DetailsPage extends StatefulWidget {
  static const routeId = '/details';

  const DetailsPage({
    super.key,
    required this.characterId,
  });

  final int characterId;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Future<Character>? characterFuture;

  static const double _minImageHeight = 160.0;
  static const double _maxImageHeight = 380.0;

  double _imageHeight = _minImageHeight;
  final double _imageAlignY = 0;

  Future<String?>? _firstSeenFuture;

  @override
  void initState() {
    super.initState();
    characterFuture =
        Repository.getCharacterDetails(widget.characterId).then((c) {
      // buscar o "first seen in"
      _firstSeenFuture = _fetchFirstSeenName(c);
      return c;
    });
  }

  void _onImageDragUpdate(double dy) {
    setState(() {
      _imageHeight =
          (_imageHeight + dy).clamp(_minImageHeight, _maxImageHeight);
    });
  }

  // buscar o nome do primeiro episódio via URL do próprio character
  Future<String?> _fetchFirstSeenName(Character c) async {
    if (c.episode.isEmpty) return null;
    try {
      final dio = Dio(BaseOptions(headers: {'Accept': 'application/json'}));
      final resp = await dio.getUri(Uri.parse(c.episode.first));
      return resp.data?['name'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context, isSecondPage: true),
      backgroundColor: AppColors.backgroundColor,
      body: FutureBuilder<Character>(
        future: characterFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return FutureBuilder<String?>(
              future: _firstSeenFuture,
              builder: (context, epSnap) {
                final firstSeenName = epSnap.data;
                final locId = idFromUrl(data.location.url);
                final orgId = idFromUrl(data.origin.url);
                final firstEpisodeUrl = data.episode.isNotEmpty ? data.episode.first : null;
                final firstEpisodeId = idFromUrl(firstEpisodeUrl);

                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9.5),
                      child: CharacterDetailsCard(
                        character: data,
                        imageHeight: _imageHeight,
                        imageAlignmentY: _imageAlignY,
                        onImageDragUpdate: _onImageDragUpdate,
                        firstSeenIn: firstSeenName,
                        locationId: locId,
                        onLocationTap: (id) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: const RouteSettings(name: LocationDetailsPage.routeId),
                              builder: (_) => LocationDetailsPage(locationId: id),
                            ),
                          );
                        },
                        originId: orgId,
                        onOriginTap: (id) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: const RouteSettings(name: LocationDetailsPage.routeId),
                              builder: (_) => LocationDetailsPage(locationId: id),
                            ),
                          );
                        },
                        firstEpisodeId: firstEpisodeId,
                        onFirstEpisodeTap: (id) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: const RouteSettings(name: EpisodeDetailsPage.routeId),
                              builder: (_) => EpisodeDetailsPage(episodeId: id),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error occurred.',
                style: TextStyle(color: AppColors.white),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
