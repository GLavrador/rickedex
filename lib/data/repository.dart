import 'dart:math';
import 'package:dio/dio.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/models/episode.dart';
import 'package:rick_morty_app/models/location.dart';
import 'package:rick_morty_app/models/paginated_characters.dart';
import 'package:rick_morty_app/models/paginated_episodes.dart' hide Info;
import 'package:rick_morty_app/models/paginated_locations.dart' hide Info;

abstract class Repository {
  static final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://rickandmortyapi.com/api',
      headers: {'Accept': 'application/json'},
      connectTimeout: 10000, 
      receiveTimeout: 10000, 
    ),
  );

  // cache simples do total (não obrigatório, mas evita pedir o count toda vez)
  static int? _charactersCountCache;

  // lista paginada de personagens, pesquisa e filtro
  static Future<PaginatedCharacters> getCharacters({
    int page = 1,
    String? name,
    String? status,
    String? species,
    String? gender,
  }) async {
    try {
      final qp = <String, dynamic>{'page': page};
      if (name != null && name.trim().isNotEmpty) {
        qp['name'] = name.trim();
      }
      if (status != null && status.trim().isNotEmpty) {
        qp['status'] = status.trim();
      }
      if (species != null && species.trim().isNotEmpty) {
        qp['species'] = species.trim();
      }
      if (gender != null && gender.trim().isNotEmpty) {
        qp['gender'] = gender.trim();
      }
      final response = await _dio.get('/character', queryParameters: qp);
      return PaginatedCharacters.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        return PaginatedCharacters(
          info: Info(count: 0, pages: 0, next: null, prev: null),
          results: const [],
        );
      }
      rethrow;
    }
  }

  // detalhes de um personagem
  static Future<Character> getCharacterDetails(int id) async {
    final response = await _dio.get('/character/$id');
    return Character.fromJson(response.data);
  }

  // lista paginada de locations, com busca e filtros
  static Future<PaginatedLocations> getLocations({
    int page = 1, 
    String? name, 
    String? type, 
    String? dimension,
  }) async {
    final query = <String, dynamic>{'page': page};
    if ((name ?? '').trim().isNotEmpty) query['name'] = name!.trim();
    if ((type ?? '').trim().isNotEmpty) query['type'] = type!.trim();
    if ((dimension ?? '').trim().isNotEmpty) query['dimension'] = dimension!.trim();

    try {
      final res = await _dio.get('/location', queryParameters: query);
      return PaginatedLocations.fromJson(res.data);
    }  on DioError catch (e) {                         
      if (e.response?.statusCode == 404) {
        return PaginatedLocations.fromJson({
          'info': {'count': 0, 'pages': 0, 'next': null, 'prev': null},
          'results': [],
        });
      }
      rethrow;
    }
  }

  // detalhes de uma location
  static Future<LocationRM> getLocationDetails(int id) async {
    final response = await _dio.get('/location/$id');
    return LocationRM.fromJson(response.data);
  }

   // lista paginada de episodios
  static Future<PaginatedEpisodes> getEpisodes({
    int page = 1,
    String? name,
    String? episodeCode,
  }) async {
    final qp = <String, dynamic>{'page': page};
    if ((name ?? '').trim().isNotEmpty) qp['name'] = name!.trim();
    if ((episodeCode ?? '').trim().isNotEmpty) qp['episode'] = episodeCode!.trim();

    try {
      final res = await _dio.get('/episode', queryParameters: qp);
      return PaginatedEpisodes.fromJson(res.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        return PaginatedEpisodes.fromJson({
          'info': {'count': 0, 'pages': 0, 'next': null, 'prev': null},
          'results': [],
        });
      }
      rethrow;
    }
  }

  // detalhes de um episodio
  static Future<Episode> getEpisodeDetails(int id) async {
    final res = await _dio.get('/episode/$id');
    return Episode.fromJson(res.data);
  }

  // personagens por uma lista de IDs
  static Future<List<Character>> getCharactersByIds(List<int> ids) async {
    if (ids.isEmpty) return <Character>[];
    final path = ids.length == 1 ? '/character/${ids.first}' : '/character/[${ids.join(',')}]';
    final res = await _dio.get(path);

    if (res.data is List) {
      return (res.data as List).map((e) => Character.fromJson(e)).toList();
    } else {
      return [Character.fromJson(res.data)];
    }
  }

  // retorna o total de personagens disponíveis (info.count) com cache simples
  static Future<int> _getCharactersCount() async {
    if (_charactersCountCache != null) return _charactersCountCache!;
    final firstPage = await getCharacters(page: 1); // sem filtros
    _charactersCountCache = firstPage.info.count;
    return _charactersCountCache!;
  }

  // sorteia um id entre 1..count
  static Future<Character> getRandomCharacter() async {
    final total = await _getCharactersCount();
    final id = Random().nextInt(total) + 1;
    final resp = await _dio.get('/character/$id');
    return Character.fromJson(resp.data);
  }

  // sorteia múltiplos personagens únicos
  static Future<List<Character>> getRandomCharacters(int amount) async {
    final total = await _getCharactersCount();
    final ids = <int>{};

    while (ids.length < amount) {
      ids.add(Random().nextInt(total) + 1);
    }
    final resp = await _dio.get('/character/${ids.join(',')}');

    return (resp.data as List)
        .map((e) => Character.fromJson(e))
        .toList();
  }
}
