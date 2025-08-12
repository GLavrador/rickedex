class LocationRM {
  LocationRM({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.residents,
    required this.url,
    required this.created,
  });

  final int id;
  final String name;
  final String type;
  final String dimension;
  final List<String> residents; // URLs de personagens
  final String url;
  final String created;

  int get residentsCount => residents.length;

  factory LocationRM.fromJson(Map<String, dynamic> json) {
    return LocationRM(
      id: json['id'],
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      dimension: json['dimension'] ?? '',
      residents: List<String>.from(json['residents'] ?? const []),
      url: json['url'] ?? '',
      created: json['created'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'dimension': dimension,
      'residents': residents,
      'url': url,
      'created': created,
    };
  }
}
