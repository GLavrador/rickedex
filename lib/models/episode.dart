class Episode {
  Episode({
    required this.id,
    required this.name,
    required this.episode,
    required this.airDate,
    required this.characters, 
  });

  final int id;
  final String name;
  final String episode;
  final String airDate;
  final List<String> characters; 

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as int,
      name: json['name'] ?? '',
      episode: json['episode'] ?? '',
      airDate: json['air_date'] ?? '',
      characters: (json['characters'] as List? ?? const []).cast<String>(), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'episode': episode,
      'air_date': airDate,
      'characters': characters, 
    };
  }
}
