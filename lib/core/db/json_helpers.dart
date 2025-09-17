import '../../core/domain/entities/paginated.dart';
import '../domain/entities/person.dart';
import '../domain/entities/person_details.dart';
import '../domain/entities/profile_image.dart';

class JsonHelpers {
  /// Convert Person from JSON
  static Person personFromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int,
      name: json['name'] as String,
      adult: json['adult'] as bool,
      knownFor: (json['knownFor'] as List).cast<int>(),
      profilePath: json['profilePath'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
    );
  }

  /// Convert Person to JSON
  static Map<String, dynamic> personToJson(Person person) {
    return {
      'id': person.id,
      'name': person.name,
      'adult': person.adult,
      'knownFor': person.knownFor,
      'profilePath': person.profilePath,
      'popularity': person.popularity,
    };
  }

  /// Convert PersonDetails from JSON
  static PersonDetails personDetailsFromJson(Map<String, dynamic> json) {
    return PersonDetails(
      id: json['id'] as int,
      name: json['name'] as String,
      adult: json['adult'] as bool,
      alsoKnownAs: (json['alsoKnownAs'] as List).cast<String>(),
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

  /// Convert PersonDetails to JSON
  static Map<String, dynamic> personDetailsToJson(PersonDetails personDetails) {
    return {
      'id': personDetails.id,
      'name': personDetails.name,
      'adult': personDetails.adult,
      'alsoKnownAs': personDetails.alsoKnownAs,
      'biography': personDetails.biography,
      'birthday': personDetails.birthday,
      'deathday': personDetails.deathday,
      'placeOfBirth': personDetails.placeOfBirth,
      'profilePath': personDetails.profilePath,
      'popularity': personDetails.popularity,
      'knownForDepartment': personDetails.knownForDepartment,
      'homepage': personDetails.homepage,
    };
  }

  /// Convert ProfileImage from JSON
  static ProfileImage profileImageFromJson(Map<String, dynamic> json) {
    return ProfileImage(
      aspectRatio: (json['aspectRatio'] as num).toDouble(),
      height: json['height'] as int,
      filePath: json['filePath'] as String,
      voteAverage: (json['voteAverage'] as num).toDouble(),
      voteCount: json['voteCount'] as int,
      width: json['width'] as int,
      iso6391: json['iso6391'] as String?,
    );
  }

  /// Convert ProfileImage to JSON
  static Map<String, dynamic> profileImageToJson(ProfileImage profileImage) {
    return {
      'aspectRatio': profileImage.aspectRatio,
      'height': profileImage.height,
      'filePath': profileImage.filePath,
      'voteAverage': profileImage.voteAverage,
      'voteCount': profileImage.voteCount,
      'width': profileImage.width,
      'iso6391': profileImage.iso6391,
    };
  }

  /// Convert Paginated from JSON
  static Paginated<T> paginatedFromJson<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return Paginated<T>(
      page: json['page'] as int,
      results: (json['results'] as List)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      totalPages: json['totalPages'] as int,
      totalResults: json['totalResults'] as int,
    );
  }

  /// Convert Paginated to JSON
  static Map<String, dynamic> paginatedToJson<T>(
    Paginated<T> paginated,
    Map<String, dynamic> Function(T) toJsonT,
  ) {
    return {
      'page': paginated.page,
      'results': paginated.results.map(toJsonT).toList(),
      'totalPages': paginated.totalPages,
      'totalResults': paginated.totalResults,
    };
  }
}
