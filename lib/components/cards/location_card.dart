import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/location.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/theme/app_typography.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.location,
    required this.onTap,
  });

  final LocationRM location;
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

            Text(
              location.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),

            // Atributos
            Row(
              children: [
                Text('Type: ', style: AppTypography.attribute(context)),
                Expanded(
                  child: Text(
                    location.type.isEmpty ? '-' : location.type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.answer(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('Dimension: ', style: AppTypography.attribute(context)),
                Expanded(
                  child: Text(
                    location.dimension.isEmpty ? '-' : location.dimension,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.answer(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${location.residentsCount} resident(s)',
              style: AppTypography.attribute(context),
            ),
          ],
        ),
      ),
    );
  }
}
