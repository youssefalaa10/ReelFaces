import 'package:flutter_test/flutter_test.dart';
import 'person_details.dart';

void main() {
  group('PersonDetails JSON Serialization', () {
    test('should convert PersonDetails to JSON correctly', () {
      // Arrange
      const personDetails = PersonDetails(
        id: 123,
        name: 'John Doe',
        adult: true,
        alsoKnownAs: ['Johnny', 'J.D.'],
        biography: 'A famous actor',
        birthday: '1980-01-01',
        placeOfBirth: 'Hollywood, CA',
        profilePath: '/profile.jpg',
        popularity: 85.5,
        knownForDepartment: 'Acting',
        homepage: 'https://johndoe.com',
      );

      // Act
      final json = personDetails.toJson();

      // Assert
      expect(json['id'], equals(123));
      expect(json['name'], equals('John Doe'));
      expect(json['adult'], equals(true));
      expect(json['alsoKnownAs'], equals(['Johnny', 'J.D.']));
      expect(json['biography'], equals('A famous actor'));
      expect(json['birthday'], equals('1980-01-01'));
      expect(json['deathday'], isNull);
      expect(json['placeOfBirth'], equals('Hollywood, CA'));
      expect(json['profilePath'], equals('/profile.jpg'));
      expect(json['popularity'], equals(85.5));
      expect(json['knownForDepartment'], equals('Acting'));
      expect(json['homepage'], equals('https://johndoe.com'));
    });

    test('should create PersonDetails from JSON correctly', () {
      // Arrange
      final json = {
        'id': 456,
        'name': 'Jane Smith',
        'adult': false,
        'alsoKnownAs': ['Jane', 'J.S.'],
        'biography': 'A talented actress',
        'birthday': '1990-05-15',
        'deathday': null,
        'placeOfBirth': 'New York, NY',
        'profilePath': '/jane_profile.jpg',
        'popularity': 92.3,
        'knownForDepartment': 'Acting',
        'homepage': 'https://janesmith.com',
      };

      // Act
      final personDetails = PersonDetails.fromJson(json);

      // Assert
      expect(personDetails.id, equals(456));
      expect(personDetails.name, equals('Jane Smith'));
      expect(personDetails.adult, equals(false));
      expect(personDetails.alsoKnownAs, equals(['Jane', 'J.S.']));
      expect(personDetails.biography, equals('A talented actress'));
      expect(personDetails.birthday, equals('1990-05-15'));
      expect(personDetails.deathday, isNull);
      expect(personDetails.placeOfBirth, equals('New York, NY'));
      expect(personDetails.profilePath, equals('/jane_profile.jpg'));
      expect(personDetails.popularity, equals(92.3));
      expect(personDetails.knownForDepartment, equals('Acting'));
      expect(personDetails.homepage, equals('https://janesmith.com'));
    });

    test('should handle null values correctly', () {
      // Arrange
      final json = {
        'id': 789,
        'name': 'Unknown Actor',
        'adult': true,
        'alsoKnownAs': null,
        'biography': null,
        'birthday': null,
        'deathday': null,
        'placeOfBirth': null,
        'profilePath': null,
        'popularity': null,
        'knownForDepartment': null,
        'homepage': null,
      };

      // Act
      final personDetails = PersonDetails.fromJson(json);

      // Assert
      expect(personDetails.id, equals(789));
      expect(personDetails.name, equals('Unknown Actor'));
      expect(personDetails.adult, equals(true));
      expect(personDetails.alsoKnownAs, isEmpty);
      expect(personDetails.biography, isNull);
      expect(personDetails.birthday, isNull);
      expect(personDetails.deathday, isNull);
      expect(personDetails.placeOfBirth, isNull);
      expect(personDetails.profilePath, isNull);
      expect(personDetails.popularity, isNull);
      expect(personDetails.knownForDepartment, isNull);
      expect(personDetails.homepage, isNull);
    });

    test('should round-trip JSON serialization correctly', () {
      // Arrange
      const originalPersonDetails = PersonDetails(
        id: 999,
        name: 'Test Actor',
        adult: true,
        alsoKnownAs: ['Test', 'T.A.'],
        biography: 'Test biography',
        birthday: '2000-01-01',
        deathday: '2020-01-01',
        placeOfBirth: 'Test City',
        profilePath: '/test.jpg',
        popularity: 50.0,
        knownForDepartment: 'Test Department',
        homepage: 'https://test.com',
      );

      // Act
      final json = originalPersonDetails.toJson();
      final deserializedPersonDetails = PersonDetails.fromJson(json);

      // Assert
      expect(deserializedPersonDetails, equals(originalPersonDetails));
    });
  });
}
