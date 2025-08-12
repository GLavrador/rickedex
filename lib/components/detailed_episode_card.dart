import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/episode.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/theme/app_typography.dart';

class DetailedEpisodeCard extends StatelessWidget {
  const DetailedEpisodeCard({
    super.key,
    required this.episode,
  });

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryColorLight,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              episode.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 15),

            Text('Episode:', style: AppTypography.attribute(context)),
            const SizedBox(height: 4),
            Text(
              episode.episode.isEmpty ? '—' : episode.episode, 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.answer(context),
            ),
            const SizedBox(height: 15),

            Text('Air date:', style: AppTypography.attribute(context)),
            const SizedBox(height: 4),
            Text(
              episode.airDate.isEmpty ? '—' : episode.airDate,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.answer(context),
            ),
            const SizedBox(height: 15),

            Text('Characters:', style: AppTypography.attribute(context)),
            const SizedBox(height: 4),
            Text(
              '${episode.characters.length} appearance(s)',
              style: AppTypography.answer(context),
            ),

            const SizedBox(height: 23),
          ],
        ),
      ),
    );
  }
}
