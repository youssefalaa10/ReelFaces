class Person {
  const Person({
    required this.id,
    required this.name,
    required this.adult,
    required this.knownFor,
    this.profilePath,
    this.popularity,
  });
  final int id;
  final String name;
  final String? profilePath;
  final double? popularity;
  final bool adult;
  final List<int> knownFor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person &&
        other.id == id &&
        other.name == name &&
        other.profilePath == profilePath &&
        other.popularity == popularity &&
        other.adult == adult &&
        other.knownFor == knownFor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        profilePath.hashCode ^
        popularity.hashCode ^
        adult.hashCode ^
        knownFor.hashCode;
  }

  @override
  String toString() {
    return 'Person(id: $id, name: $name, profilePath: $profilePath, popularity: $popularity, adult: $adult, knownFor: $knownFor)';
  }
}
