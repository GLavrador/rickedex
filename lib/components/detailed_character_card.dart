import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class CharacterDetailsCard extends StatelessWidget {
  const CharacterDetailsCard({
    Key? key,
    required this.character,
  }) : super(key: key);

  final Character character;

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
      child: SizedBox(
        height: 383,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'character-${character.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  character.image,
                  width: double.infinity,
                  height: 160,     
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const SizedBox(
                      height: 160,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (_, __, ___) => SizedBox(
                    height: 160,
                    child: Center(
                      child: Icon(Icons.broken_image, color: AppColors.white),
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
                    style: TextStyle(
                      color: AppColors.white,
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
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Last known location:',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    character.location.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                      color: AppColors.white,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Episodes:',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    '$episodesCount appearances',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                      color: AppColors.white,
                    ),
                  ),

                  // TODO: First seen in
                  // const SizedBox(height: 16),
                  // Text(
                  //   'First seen in:',
                  //   style: TextStyle(
                  //     fontSize: 12.5,
                  //     color: AppColors.white,
                  //   ),
                  // ),
                  // Text(
                  //   '...', // nome do episódio/lugar
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 12.5,
                  //     color: AppColors.white,
                  //   ),
                  // ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
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
