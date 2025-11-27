import 'package:flutter/foundation.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/character.dart';

class FeedService {
  FeedService._();
  static final FeedService instance = FeedService._();

  final ValueNotifier<List<Character>?> characters = ValueNotifier(null);

  Future<void> loadCharacters({bool force = false}) async {

    if (characters.value != null && !force) return;

    try {
      final list = await Repository.getRandomCharacters(5);
      characters.value = list;
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}