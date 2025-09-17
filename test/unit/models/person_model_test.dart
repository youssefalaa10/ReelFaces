import 'package:flutter_test/flutter_test.dart';
import 'package:reelfaces/features/person_details/data/model/person_model.dart';

void main() {
  group('PersonModel', () {
    test('should create PersonModel from JSON correctly', () {
      final jsonData = {
        'id': 123,
        'name': 'Youssef Alaa',
        'profile_path': '/path/to/profile.jpg',
        'biography': 'A famous actor',
        'birthday': '1990-01-01',
        'place_of_birth': 'Hollywood, CA',
        'popularity': 85.5,
        'known_for': ['Action', 'Drama'],
        'images': ['image1.jpg', 'image2.jpg'],
      };

      final person = PersonModel.fromJson(jsonData);

      expect(person.id, equals(123));
      expect(person.name, equals('Youssef Alaa'));
      expect(person.profilePath, equals('/path/to/profile.jpg'));
      expect(person.biography, equals('A famous actor'));
      expect(person.birthDate, equals('1990-01-01'));
      expect(person.placeOfBirth, equals('Hollywood, CA'));
      expect(person.popularity, equals(85.5));
      expect(person.knownFor, equals(['Action', 'Drama']));
      expect(person.images, equals(['image1.jpg', 'image2.jpg']));
    });

    test('should handle missing JSON fields with default values', () {
      final jsonData = {'id': 456, 'name': 'Saif'};

      final person = PersonModel.fromJson(jsonData);

      expect(person.id, equals(456));
      expect(person.name, equals('Saif'));
      expect(person.profilePath, isNull);
      expect(person.biography, isNull);
      expect(person.birthDate, isNull);
      expect(person.placeOfBirth, isNull);
      expect(person.popularity, equals(0.0));
      expect(person.knownFor, isEmpty);
      expect(person.images, isEmpty);
    });

    test('should convert PersonModel to JSON correctly', () {
      final person = const PersonModel(
        id: 789,
        name: 'Test Actor',
        profilePath: '/test/path.jpg',
        biography: 'Test biography',
        birthDate: '1985-05-15',
        placeOfBirth: 'Test City',
        popularity: 75.0,
        knownFor: ['Comedy', 'Romance'],
        images: ['test1.jpg', 'test2.jpg'],
      );

      // Act
      final json = person.toJson();

      expect(json['id'], equals(789));
      expect(json['name'], equals('Test Actor'));
      expect(json['profile_path'], equals('/test/path.jpg'));
      expect(json['biography'], equals('Test biography'));
      expect(json['birthday'], equals('1985-05-15'));
      expect(json['place_of_birth'], equals('Test City'));
      expect(json['popularity'], equals(75.0));
      expect(json['known_for'], equals(['Comedy', 'Romance']));
      expect(json['images'], equals(['test1.jpg', 'test2.jpg']));
    });
  });
}
