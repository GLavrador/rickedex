import 'package:flutter/foundation.dart';
import 'package:rick_morty_app/data/repository.dart';
import 'package:rick_morty_app/models/character.dart';

class FeedService {
  FeedService._();
  static final FeedService instance = FeedService._();

  final ValueNotifier<List<Character>?> characters = ValueNotifier(null);
  
  final ValueNotifier<List<Character>?> randomCharacters = ValueNotifier(null);

  Future<void> loadAll({bool force = false}) async {
    await Future.wait([
      loadCharacters(force: force),
      loadRandomCharacters(force: force),
    ]);
  }

  Future<void> loadCharacters({bool force = false}) async {

    if (characters.value != null && !force) return;
    
    try {
      final list = await Repository.getRandomCharacters(5);
      characters.value = list;
    } catch (e) {
      debugPrint('Error loading characters: $e');
    }
  }

  Future<void> loadRandomCharacters({bool force = false}) async {
    if (randomCharacters.value != null && !force) return;
    try {
      final list = await Repository.getRandomCharacters(10);
      randomCharacters.value = list;
    } catch (e) {
      debugPrint('Error loading random: $e');
    }
  }
}