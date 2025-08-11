import 'package:dio/dio.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/models/episode.dart';
import 'package:rick_morty_app/models/paginated_characters.dart';

abstract class Repository {
  static final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://rickandmortyapi.com/api',
      headers: {'Accept': 'application/json'},
      connectTimeout: 10000, 
      receiveTimeout: 10000, 
    ),
  );

  // lista paginada de personagens e pesquisa
  static Future<PaginatedCharacters> getCharacters({
    int page = 1,
    String? name,
  }) async {
    try {
      final qp = <String, dynamic>{'page': page};
      if (name != null && name.trim().isNotEmpty) {
        qp['name'] = name.trim();
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

  // buscar usando a URL completa de `info.next` / `info.prev`
  static Future<PaginatedCharacters> getCharactersFromUrl(String url) async {
    final response = await _dio.getUri(Uri.parse(url));
    return PaginatedCharacters.fromJson(response.data);
  }

  // buscar episódio a partir da URL
  static Future<Episode> getEpisodeFromUrl(String url) async {
    final response = await _dio.getUri(Uri.parse(url));
    return Episode.fromJson(response.data);
  }
}
