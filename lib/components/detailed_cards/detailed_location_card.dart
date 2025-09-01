import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/location.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/theme/app_typography.dart';

class LocationDetailsCard extends StatelessWidget {
  const LocationDetailsCard({
    super.key,
    required this.location,
    required this.residentCharacters,   
    required this.onResidentTap,        
  });

  final LocationRM location;
  final List<Character> residentCharacters;
  final ValueChanged<int> onResidentTap; // recebe o id do personagem

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
            Text(
              location.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 15),

            Text('Type:', style: AppTypography.attribute(context)),
            const SizedBox(height: 4),
            Text(
              location.type.isEmpty ? '—' : location.type,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.answer(context),
            ),
            const SizedBox(height: 15),

            Text('Dimension:', style: AppTypography.attribute(context)),
            const SizedBox(height: 4),
            Text(
              location.dimension.isEmpty ? '—' : location.dimension,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.answer(context),
            ),
            const SizedBox(height: 15),

            Text('Residents:', style: AppTypography.attribute(context)),
            const SizedBox(height: 4),
            Text(
              '${location.residentsCount} resident(s)',
              style: AppTypography.answer(context),
            ),
            const SizedBox(height: 15),

            if (residentCharacters.isNotEmpty) ...[
              Text('Residents (${residentCharacters.length}):', style: AppTypography.attribute(context)),
              const SizedBox(height: 8),

              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 170),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    primary: false, // importante p/ NÃO ocupar altura toda
                    child: Wrap(
                      spacing: 8, runSpacing: 8,
                      children: residentCharacters.map((c) {
                        return InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                          onTap: () => onResidentTap(c.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColorDark.withValues(alpha: 0.2),
                              borderRadius: const BorderRadius.all(Radius.circular(16)),
                            ),
                            child: Text(c.name, style: AppTypography.answer(context)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 23),
          ],
        ),
      ),
    );
  }
}
