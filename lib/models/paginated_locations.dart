import 'location.dart';

class PaginatedLocations {
  PaginatedLocations({
    required this.info,
    required this.results,
  });

  final Info info;
  final List<LocationRM> results;

  factory PaginatedLocations.fromJson(Map<String, dynamic> json) {
    return PaginatedLocations(
      info: Info.fromJson(json['info']),
      results: List.from(json['results'])
          .map((e) => LocationRM.fromJson(e))
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
    required this.next,
    required this.prev,
  });

  final int count;
  final int pages;
  final String? next;
  final String? prev;

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      count: json['count'] ?? 0,
      pages: json['pages'] ?? 0,
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
