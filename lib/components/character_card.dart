import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    Key? key,
    required this.character,
    required this.onTap,
  }) : super(key: key);

  final Character character;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryColorLight,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'character-${character.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  character.image,
                  width: double.infinity,
                  height: 120,         
                  fit: BoxFit.cover,          
                  alignment: const Alignment(0, -0.25), // foca um pouco mais no topo
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (_, __, ___) => SizedBox(
                    height: 120,
                    child: Center(
                      child: Icon(Icons.broken_image, color: AppColors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    character.name.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w900, 
                      fontSize: 14.5,
                      height: 1.0,                
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
