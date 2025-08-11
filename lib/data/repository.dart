import 'package:dio/dio.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/models/paginated_characters.dart';

abstract class Repository {
  static final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://rickandmortyapi.com/api',
      headers: {'Accept': 'application/json'},
    ),
  );

  // lista paginada de personagens
  static Future<PaginatedCharacters> getCharacters({int page = 1}) async {
    final response = await _dio.get(
      '/character',
      queryParameters: {'page': page},
    );
    return PaginatedCharacters.fromJson(response.data);
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
}
