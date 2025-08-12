import 'package:rick_morty_app/models/episode.dart';

class PaginatedEpisodes {
  PaginatedEpisodes({required this.info, required this.results});
  final Info info;
  final List<Episode> results;

  factory PaginatedEpisodes.fromJson(Map<String, dynamic> json) {
    return PaginatedEpisodes(
      info: Info.fromJson(json['info']),
      results: List.from(json['results']).map((e) => Episode.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'info': info.toJson(),
    'results': results.map((e) => e.toJson()).toList(),
  };
}

class Info {
  Info({required this.count, required this.pages, this.next, this.prev});
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    count: json['count'] ?? 0,
    pages: json['pages'] ?? 0,
    next: json['next'],
    prev: json['prev'],
  );

  Map<String, dynamic> toJson() => {
    'count': count,
    'pages': pages,
    'next': next,
    'prev': prev,
  };
}
