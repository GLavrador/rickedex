import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/theme/app_typography.dart';

class CharacterDetailsCard extends StatelessWidget {
  const CharacterDetailsCard({
    Key? key,
    required this.character,
    required this.imageHeight,
    required this.imageAlignmentY,
    required this.onImageDragUpdate,
    this.firstSeenIn,
  }) : super(key: key);

  final Character character;

  final double imageHeight;
  final double imageAlignmentY;
  final ValueChanged<double> onImageDragUpdate;
  final String? firstSeenIn;

  @override
  Widget build(BuildContext context) {

    return Card(
      color: AppColors.primaryColorLight,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'character-${character.id}',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: (details) =>
                  onImageDragUpdate(details.delta.dy),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        character.image,
                        fit: BoxFit.cover,
                        alignment: Alignment(0, imageAlignmentY),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return SizedBox(
                            height: imageHeight,
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (_, __, ___) => SizedBox(
                          height: imageHeight,
                          child: Center(
                            child: Icon(Icons.broken_image, color: AppColors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.6),
                              width: 0.75,
                            ),
                          ),
                          child: Icon(
                            imageHeight >= 380.0
                                ? Icons.expand_less
                                : Icons.expand_more,
                            size: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14.5, 
                  ),
                ),
                const SizedBox(height: 38),

                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _statusColor(character.status),
                        border: Border.all(color: AppColors.white, width: 1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${character.status} - ${character.species.isNotEmpty ? character.species : 'Unknown'}',
                        style: AppTypography.answer(context)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Text(
                  'Last known location:',
                  style: AppTypography.attribute(context)
                ),
                const SizedBox(height: 4),

                Text(
                  character.location.name,
                  style: AppTypography.answer(context)
                ),
                const SizedBox(height: 15),

                Text(
                  'First seen in:',
                  style: AppTypography.attribute(context)
                ),
                const SizedBox(height: 4),

                Text(
                  firstSeenIn ?? '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.answer(context)
                ),
                const SizedBox(height: 15),

                Text(
                  'Episodes:',
                  style: AppTypography.attribute(context)
                ),
                const SizedBox(height: 4),

                Text(
                  '${character.episode.length} appearances',
                  style: AppTypography.answer(context)
                ),

                // distância entre última frase e fim do card 43px
                const SizedBox(height: 23),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'dead':
        return const Color(0xFFD53C2E);
      case 'alive':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
