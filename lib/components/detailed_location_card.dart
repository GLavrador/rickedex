import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/location.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/theme/app_typography.dart';

class LocationDetailsCard extends StatelessWidget {
  const LocationDetailsCard({
    super.key,
    required this.location,
    this.residentNames,
  });

  final LocationRM location;
  final List<String>? residentNames; // pode ser nula enquanto carrega

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // título
            Text(
              location.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),

            _rowAttr(context, 'Type', location.type),
            const SizedBox(height: 6),
            _rowAttr(context, 'Dimension', location.dimension),
            const SizedBox(height: 6),
            _rowAttr(context, 'Residents', '${location.residentsCount}'),

            const SizedBox(height: 16),

            if (residentNames != null) ...[
              Text('Some residents:', style: AppTypography.attribute(context)),
              const SizedBox(height: 8),
              if (residentNames!.isEmpty)
                Text('-', style: AppTypography.answer(context))
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: residentNames!
                      .map((n) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColorDark.withValues(alpha: 0.2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                            ),
                            child: Text(n, style: AppTypography.answer(context)),
                          ))
                      .toList(),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _rowAttr(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: AppTypography.attribute(context)),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            style: AppTypography.answer(context),
          ),
        ),
      ],
    );
  }
}
