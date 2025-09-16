class PersonModel {
  const PersonModel({
    required this.id,
    required this.name,
    this.profilePath,
    this.biography,
    this.birthDate,
    this.placeOfBirth,
    this.popularity = 0.0,
    this.knownFor = const [],
    this.images = const [],
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profilePath: json['profile_path'],
      biography: json['biography'],
      birthDate: json['birthday'],
      placeOfBirth: json['place_of_birth'],
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      knownFor: List<String>.from(json['known_for'] ?? []),
      images: List<String>.from(json['images'] ?? []),
    );
  }
  final int id;
  final String name;
  final String? profilePath;
  final String? biography;
  final String? birthDate;
  final String? placeOfBirth;
  final double popularity;
  final List<String> knownFor;
  final List<String> images;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': profilePath,
      'biography': biography,
      'birthday': birthDate,
      'place_of_birth': placeOfBirth,
      'popularity': popularity,
      'known_for': knownFor,
      'images': images,
    };
  }

  PersonModel copyWith({
    int? id,
    String? name,
    String? profilePath,
    String? biography,
    String? birthDate,
    String? placeOfBirth,
    double? popularity,
    List<String>? knownFor,
    List<String>? images,
  }) {
    return PersonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePath: profilePath ?? this.profilePath,
      biography: biography ?? this.biography,
      birthDate: birthDate ?? this.birthDate,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      popularity: popularity ?? this.popularity,
      knownFor: knownFor ?? this.knownFor,
      images: images ?? this.images,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PersonModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PersonModel(id: $id, name: $name, popularity: $popularity)';
  }
}
