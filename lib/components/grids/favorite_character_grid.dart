import 'package:flutter/material.dart';
import '../../models/character.dart';
import '../../pages/details_page.dart';
import '../cards/character_card.dart';

class CharacterGridView extends StatelessWidget {
  final List<Character> characters;

  const CharacterGridView({
    super.key,
    required this.characters,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        GridView.builder(
          itemCount: characters.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (context, index) {
            final character = characters[index];
            return CharacterCard(
              character: character,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    settings: const RouteSettings(name: DetailsPage.routeId),
                    builder: (_) => DetailsPage(characterId: character.id),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}