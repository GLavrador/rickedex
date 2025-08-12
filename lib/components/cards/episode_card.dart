import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/episode.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/theme/app_typography.dart';

class EpisodeCard extends StatelessWidget {
  const EpisodeCard({super.key, required this.episode, required this.onTap});
  final Episode episode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.appBarColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(episode.name,
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.white, fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Text('Episode: ', style: AppTypography.attribute(context)),
              Expanded(child: Text(episode.episode,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: AppTypography.answer(context),
              )),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              Text('Air date: ', style: AppTypography.attribute(context)),
              Expanded(child: Text(
                (episode.airDate).isEmpty ? '-' : episode.airDate,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: AppTypography.answer(context),
              )),
            ]),
          ],
        ),
      ),
    );
  }
}
