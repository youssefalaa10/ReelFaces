class PersonDetails {
  /// Create PersonDetails from JSON
  factory PersonDetails.fromJson(Map<String, dynamic> json) {
    return PersonDetails(
      id: json['id'] as int,
      name: json['name'] as String,
      adult: json['adult'] as bool? ?? false,
      alsoKnownAs: (json['alsoKnownAs'] as List?)?.cast<String>() ?? [],
      biography: json['biography'] as String?,
      birthday: json['birthday'] as String?,
      deathday: json['deathday'] as String?,
      placeOfBirth: json['placeOfBirth'] as String?,
      profilePath: json['profilePath'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      knownForDepartment: json['knownForDepartment'] as String?,
      homepage: json['homepage'] as String?,
    );
  }
  const PersonDetails({
    required this.id,
    required this.name,
    required this.adult,
    required this.alsoKnownAs,
    this.biography,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    this.profilePath,
    this.popularity,
    this.knownForDepartment,
    this.homepage,
  });
  final int id;
  final String name;
  final String? biography;
  final String? birthday;
  final String? deathday;
  final String? placeOfBirth;
  final String? profilePath;
  final double? popularity;
  final bool adult;
  final String? knownForDepartment;
  final String? homepage;
  final List<String> alsoKnownAs;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PersonDetails &&
        other.id == id &&
        other.name == name &&
        other.biography == biography &&
        other.birthday == birthday &&
        other.deathday == deathday &&
        other.placeOfBirth == placeOfBirth &&
        other.profilePath == profilePath &&
        other.popularity == popularity &&
        other.adult == adult &&
        other.knownForDepartment == knownForDepartment &&
        other.homepage == homepage &&
        other.alsoKnownAs == alsoKnownAs;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        biography.hashCode ^
        birthday.hashCode ^
        deathday.hashCode ^
        placeOfBirth.hashCode ^
        profilePath.hashCode ^
        popularity.hashCode ^
        adult.hashCode ^
        knownForDepartment.hashCode ^
        homepage.hashCode ^
        alsoKnownAs.hashCode;
  }

  @override
  String toString() {
    return 'PersonDetails(id: $id, name: $name, biography: $biography, birthday: $birthday, deathday: $deathday, placeOfBirth: $placeOfBirth, profilePath: $profilePath, popularity: $popularity, adult: $adult, knownForDepartment: $knownForDepartment, homepage: $homepage, alsoKnownAs: $alsoKnownAs)';
  }

  /// Convert PersonDetails to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'adult': adult,
      'alsoKnownAs': alsoKnownAs,
      'biography': biography,
      'birthday': birthday,
      'deathday': deathday,
      'placeOfBirth': placeOfBirth,
      'profilePath': profilePath,
      'popularity': popularity,
      'knownForDepartment': knownForDepartment,
      'homepage': homepage,
    };
  }
}
