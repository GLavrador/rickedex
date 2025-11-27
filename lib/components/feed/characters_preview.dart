import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/feed/feed_image_stack.dart';
import 'package:rick_morty_app/components/feed/feed_skeleton_stack.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/pages/character_details_page.dart';

class CharactersPreview extends StatelessWidget {
  const CharactersPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Character>>(
      future: Repository.getRandomCharacters(5),
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 110,
            height: 100,
            child: Center(child: FeedSkeletonStack()),
          );
        }

        if (snap.hasError) {
          return const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text('No connection', style: TextStyle(color: Colors.white)),
          );
        }

        final data = snap.data ?? <Character>[];
        if (data.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text('No data', style: TextStyle(color: Colors.white)),
          );
        }

        final urls = data.map((e) => e.image).toList();
        final ids = data.map((e) => e.id).toList();

        return FeedImageStack(
          imagePaths: urls,
          ids: ids,
          onTap: (id) {
            Navigator.pushNamed(
              c,
              CharacterDetailsPage.routeId,
              arguments: id,
            );
          },
        );
      },
    );
  }
}