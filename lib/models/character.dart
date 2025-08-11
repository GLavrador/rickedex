class Character {
  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  final int id;
  final String name;
  final String status; 
  final String species;
  final String type; 
  final String gender;
  final Place origin; 
  final Place location; 
  final String image; 
  final List<String> episode; 
  final String url; 
  final String created; 

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'] ?? '',
      gender: json['gender'],
      origin: Place.fromJson(json['origin']),
      location: Place.fromJson(json['location']),
      image: json['image'],
      episode: List<String>.from(json['episode'] ?? const []),
      url: json['url'],
      created: json['created'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': origin.toJson(),
      'location': location.toJson(),
      'image': image,
      'episode': episode,
      'url': url,
      'created': created,
    };
  }
}

class Place {
  Place({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}
