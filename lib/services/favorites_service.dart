import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class FavoritesService {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  final ValueNotifier<Set<int>> favorites = ValueNotifier<Set<int>>({});

  static const _prefsKey = 'favorite_character_ids';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final list = (jsonDecode(raw) as List).cast<int>();
      favorites.value = list.toSet();
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final list = favorites.value.toList()..sort();
    await prefs.setString(_prefsKey, jsonEncode(list));
  }

  bool isFavorite(int id) => favorites.value.contains(id);

  Future<void> toggle(int id) async {
    final set = Set<int>.from(favorites.value);
    if (!set.add(id)) set.remove(id);
    favorites.value = set;
    await _persist();
  }

  Future<void> add(int id) async {
    final set = Set<int>.from(favorites.value)..add(id);
    favorites.value = set;
    await _persist();
  }

  Future<void> remove(int id) async {
    final set = Set<int>.from(favorites.value)..remove(id);
    favorites.value = set;
    await _persist();
  }

  Future<void> clearAll() async {
  favorites.value = <int>{};
  await _persist();
}
}
