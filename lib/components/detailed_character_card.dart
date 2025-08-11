import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class CharacterDetailsCard extends StatelessWidget {
  const CharacterDetailsCard({
    Key? key,
    required this.character,
    required this.imageHeight,
    required this.imageAlignmentY,
    required this.onImageDragUpdate,
  }) : super(key: key);

  final Character character;

  final double imageHeight;
  final double imageAlignmentY;
  final ValueChanged<double> onImageDragUpdate;

  @override
  Widget build(BuildContext context) {
    final episodesCount = character.episode.length;

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
                borderRadius:
                    const BorderRadius.all(Radius.circular(10)),
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
            padding:
                const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 20),
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
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),

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
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const Text(
                  'Last known location:',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white,
                  ),
                ),
                Text(
                  character.location.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Episodes:',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$episodesCount appearances',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
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
