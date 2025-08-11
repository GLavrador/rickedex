class Episode {
  Episode({
    required this.id,
    required this.name,
    required this.episode,
    required this.airDate,
  });

  final int id;
  final String name;
  final String episode;
  final String airDate;

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      name: json['name'],
      episode: json['episode'],
      airDate: json['air_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'episode': episode,
      'air_date': airDate,
    };
  }
}
