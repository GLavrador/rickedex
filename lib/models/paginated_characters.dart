import 'character.dart';

class PaginatedCharacters {
  PaginatedCharacters({
    required this.info,
    required this.results,
  });

  final Info info;
  final List<Character> results;

  factory PaginatedCharacters.fromJson(Map<String, dynamic> json) {
    return PaginatedCharacters(
      info: Info.fromJson(json['info']),
      results: List.from(json['results'])
          .map((e) => Character.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': info.toJson(),
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}

class Info {
  Info({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  final int count;
  final int pages;
  final String? next; 
  final String? prev;

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      count: json['count'],
      pages: json['pages'],
      next: json['next'],
      prev: json['prev'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'pages': pages,
      'next': next,
      'prev': prev,
    };
  }
}
