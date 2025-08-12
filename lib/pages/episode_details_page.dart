import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/detailed_cards/detailed_episode_card.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/episode.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class EpisodeDetailsPage extends StatelessWidget {
  static const routeId = '/episode_details';
  const EpisodeDetailsPage({super.key, required this.episodeId});
  final int episodeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context, isSecondPage: true),
      backgroundColor: AppColors.backgroundColor,
      body: FutureBuilder<Episode>(
        future: Repository.getEpisodeDetails(episodeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('Ocorreu um erro.', style: TextStyle(color: AppColors.white)),
            );
          }
          final ep = snapshot.data!;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DetailedEpisodeCard(episode: ep),
            ],
          );
        },
      ),
    );
  }
}
