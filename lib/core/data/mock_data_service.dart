import '../../features/image_viewer/data/model/image_model.dart';
import '../../features/person_details/data/model/person_model.dart';

class MockDataService {
  static const List<PersonModel> mockPeople = [
    PersonModel(
      id: 1,
      name: 'Emma Stone',
      profilePath:
          'https://image.tmdb.org/t/p/w500/2hwX2yu4xWqkGlf7qo8P0Qz3Q9.jpg',
      biography:
          'Emma Stone is an American actress and producer. She is the recipient of various accolades, including an Academy Award, a British Academy Film Award, and a Golden Globe Award.',
      birthDate: '1988-11-06',
      placeOfBirth: 'Scottsdale, Arizona, USA',
      popularity: 85.2,
      knownFor: ['La La Land', 'The Help', 'Birdman', 'Easy A'],
      images: [
        'https://image.tmdb.org/t/p/w500/2hwX2yu4xWqkGlf7qo8P0Qz3Q9.jpg',
        'https://image.tmdb.org/t/p/w500/8Z7d7K9x3Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q.jpg',
        'https://image.tmdb.org/t/p/w500/9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q9Q.jpg',
        'https://image.tmdb.org/t/p/w500/1Q1Q1Q1Q1Q1Q1Q1Q1Q1Q1Q1Q1Q1Q1Q.jpg',
        'https://image.tmdb.org/t/p/w500/2Q2Q2Q2Q2Q2Q2Q2Q2Q2Q2Q2Q2Q2Q2Q.jpg',
        'https://image.tmdb.org/t/p/w500/3Q3Q3Q3Q3Q3Q3Q3Q3Q3Q3Q3Q3Q3Q3Q.jpg',
      ],
    ),
    PersonModel(
      id: 2,
      name: 'Ryan Gosling',
      profilePath:
          'https://image.tmdb.org/t/p/w500/4J4J4J4J4J4J4J4J4J4J4J4J4J4J4J.jpg',
      biography:
          'Ryan Gosling is a Canadian actor, musician, and producer. He began his career as a child star on the Disney Channel\'s The Mickey Mouse Club.',
      birthDate: '1980-11-12',
      placeOfBirth: 'London, Ontario, Canada',
      popularity: 78.5,
      knownFor: ['La La Land', 'Drive', 'The Notebook', 'Blade Runner 2049'],
      images: [
        'https://image.tmdb.org/t/p/w500/4J4J4J4J4J4J4J4J4J4J4J4J4J4J4J.jpg',
        'https://image.tmdb.org/t/p/w500/5J5J5J5J5J5J5J5J5J5J5J5J5J5J5J.jpg',
        'https://image.tmdb.org/t/p/w500/6J6J6J6J6J6J6J6J6J6J6J6J6J6J6J.jpg',
        'https://image.tmdb.org/t/p/w500/7J7J7J7J7J7J7J7J7J7J7J7J7J7J7J.jpg',
        'https://image.tmdb.org/t/p/w500/8J8J8J8J8J8J8J8J8J8J8J8J8J8J8J.jpg',
        'https://image.tmdb.org/t/p/w500/9J9J9J9J9J9J9J9J9J9J9J9J9J9J9J.jpg',
      ],
    ),
    PersonModel(
      id: 3,
      name: 'Margot Robbie',
      profilePath:
          'https://image.tmdb.org/t/p/w500/3K3K3K3K3K3K3K3K3K3K3K3K3K3K3K.jpg',
      biography:
          'Margot Robbie is an Australian actress and producer. She is known for her roles in The Wolf of Wall Street, Suicide Squad, and I, Tonya.',
      birthDate: '1990-07-02',
      placeOfBirth: 'Dalby, Queensland, Australia',
      popularity: 92.1,
      knownFor: [
        'The Wolf of Wall Street',
        'Suicide Squad',
        'I, Tonya',
        'Once Upon a Time in Hollywood',
      ],
      images: [
        'https://image.tmdb.org/t/p/w500/3K3K3K3K3K3K3K3K3K3K3K3K3K3K3K.jpg',
        'https://image.tmdb.org/t/p/w500/4K4K4K4K4K4K4K4K4K4K4K4K4K4K4K.jpg',
        'https://image.tmdb.org/t/p/w500/5K5K5K5K5K5K5K5K5K5K5K5K5K5K5K.jpg',
        'https://image.tmdb.org/t/p/w500/6K6K6K6K6K6K6K6K6K6K6K6K6K6K6K.jpg',
        'https://image.tmdb.org/t/p/w500/7K7K7K7K7K7K7K7K7K7K7K7K7K7K7K.jpg',
        'https://image.tmdb.org/t/p/w500/8K8K8K8K8K8K8K8K8K8K8K8K8K8K8K.jpg',
      ],
    ),
    PersonModel(
      id: 4,
      name: 'Leonardo DiCaprio',
      profilePath:
          'https://image.tmdb.org/t/p/w500/1L1L1L1L1L1L1L1L1L1L1L1L1L1L1L.jpg',
      biography:
          'Leonardo DiCaprio is an American actor and producer. He has been nominated for six Academy Awards and won the Academy Award for Best Actor for The Revenant.',
      birthDate: '1974-11-11',
      placeOfBirth: 'Los Angeles, California, USA',
      popularity: 95.8,
      knownFor: [
        'Titanic',
        'The Revenant',
        'Inception',
        'The Wolf of Wall Street',
      ],
      images: [
        'https://image.tmdb.org/t/p/w500/1L1L1L1L1L1L1L1L1L1L1L1L1L1L1L.jpg',
        'https://image.tmdb.org/t/p/w500/2L2L2L2L2L2L2L2L2L2L2L2L2L2L2L.jpg',
        'https://image.tmdb.org/t/p/w500/3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L.jpg',
        'https://image.tmdb.org/t/p/w500/4L4L4L4L4L4L4L4L4L4L4L4L4L4L4L.jpg',
        'https://image.tmdb.org/t/p/w500/5L5L5L5L5L5L5L5L5L5L5L5L5L5L5L.jpg',
        'https://image.tmdb.org/t/p/w500/6L6L6L6L6L6L6L6L6L6L6L6L6L6L6L.jpg',
      ],
    ),
    PersonModel(
      id: 5,
      name: 'Scarlett Johansson',
      profilePath:
          'https://image.tmdb.org/t/p/w500/2S2S2S2S2S2S2S2S2S2S2S2S2S2S2S.jpg',
      biography:
          'Scarlett Johansson is an American actress and singer. She is the world\'s highest-paid actress and has been featured multiple times on the Forbes Celebrity 100 list.',
      birthDate: '1984-11-22',
      placeOfBirth: 'New York City, New York, USA',
      popularity: 88.7,
      knownFor: [
        'Lost in Translation',
        'The Avengers',
        'Marriage Story',
        'Black Widow',
      ],
      images: [
        'https://image.tmdb.org/t/p/w500/2S2S2S2S2S2S2S2S2S2S2S2S2S2S2S.jpg',
        'https://image.tmdb.org/t/p/w500/3S3S3S3S3S3S3S3S3S3S3S3S3S3S3S.jpg',
        'https://image.tmdb.org/t/p/w500/4S4S4S4S4S4S4S4S4S4S4S4S4S4S4S.jpg',
        'https://image.tmdb.org/t/p/w500/5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S.jpg',
        'https://image.tmdb.org/t/p/w500/6S6S6S6S6S6S6S6S6S6S6S6S6S6S6S.jpg',
        'https://image.tmdb.org/t/p/w500/7S7S7S7S7S7S7S7S7S7S7S7S7S7S7S.jpg',
      ],
    ),
    PersonModel(
      id: 6,
      name: 'Chris Evans',
      profilePath:
          'https://image.tmdb.org/t/p/w500/3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C.jpg',
      biography:
          'Chris Evans is an American actor, director, and producer. He is best known for his role as Captain America in the Marvel Cinematic Universe.',
      birthDate: '1981-06-13',
      placeOfBirth: 'Boston, Massachusetts, USA',
      popularity: 82.3,
      knownFor: [
        'Captain America',
        'Snowpiercer',
        'Knives Out',
        'The Avengers',
      ],
      images: [
        'https://image.tmdb.org/t/p/w500/3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C.jpg',
        'https://image.tmdb.org/t/p/w500/4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C.jpg',
        'https://image.tmdb.org/t/p/w500/5C5C5C5C5C5C5C5C5C5C5C5C5C5C5C.jpg',
        'https://image.tmdb.org/t/p/w500/6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C.jpg',
        'https://image.tmdb.org/t/p/w500/7C7C7C7C7C7C7C7C7C7C7C7C7C7C7C.jpg',
        'https://image.tmdb.org/t/p/w500/8C8C8C8C8C8C8C8C8C8C8C8C8C8C8C.jpg',
      ],
    ),
    PersonModel(
      id: 7,
      name: 'Gal Gadot',
      profilePath:
          'https://image.tmdb.org/t/p/w500/4G4G4G4G4G4G4G4G4G4G4G4G4G4G4G.jpg',
      biography:
          'Gal Gadot is an Israeli actress, model, and producer. She is best known for her role as Wonder Woman in the DC Extended Universe.',
      birthDate: '1985-04-30',
      placeOfBirth: 'Petah Tikva, Israel',
      popularity: 79.6,
      knownFor: [
        'Wonder Woman',
        'Fast & Furious',
        'Justice League',
        'Red Notice',
      ],
      images: [
        'https://image.tmdb.org/t/p/w500/4G4G4G4G4G4G4G4G4G4G4G4G4G4G4G.jpg',
        'https://image.tmdb.org/t/p/w500/5G5G5G5G5G5G5G5G5G5G5G5G5G5G5G.jpg',
        'https://image.tmdb.org/t/p/w500/6G6G6G6G6G6G6G6G6G6G6G6G6G6G6G.jpg',
        'https://image.tmdb.org/t/p/w500/7G7G7G7G7G7G7G7G7G7G7G7G7G7G7G.jpg',
        'https://image.tmdb.org/t/p/w500/8G8G8G8G8G8G8G8G8G8G8G8G8G8G8G.jpg',
        'https://image.tmdb.org/t/p/w500/9G9G9G9G9G9G9G9G9G9G9G9G9G9G9G.jpg',
      ],
    ),
    PersonModel(
      id: 8,
      name: 'Tom Holland',
      profilePath:
          'https://image.tmdb.org/t/p/w500/5T5T5T5T5T5T5T5T5T5T5T5T5T5T5T.jpg',
      biography:
          'Tom Holland is an English actor and dancer. He is best known for playing Spider-Man in the Marvel Cinematic Universe.',
      birthDate: '1996-06-01',
      placeOfBirth: 'Kingston upon Thames, England',
      popularity: 87.4,
      knownFor: ['Spider-Man', 'Cherry', 'The Impossible', 'Uncharted'],
      images: [
        'https://image.tmdb.org/t/p/w500/5T5T5T5T5T5T5T5T5T5T5T5T5T5T5T.jpg',
        'https://image.tmdb.org/t/p/w500/6T6T6T6T6T6T6T6T6T6T6T6T6T6T6T.jpg',
        'https://image.tmdb.org/t/p/w500/7T7T7T7T7T7T7T7T7T7T7T7T7T7T7T.jpg',
        'https://image.tmdb.org/t/p/w500/8T8T8T8T8T8T8T8T8T8T8T8T8T8T8T.jpg',
        'https://image.tmdb.org/t/p/w500/9T9T9T9T9T9T9T9T9T9T9T9T9T9T9T.jpg',
        'https://image.tmdb.org/t/p/w500/1T1T1T1T1T1T1T1T1T1T1T1T1T1T1T.jpg',
      ],
    ),
  ];

  static PersonModel? getPersonById(int id) {
    try {
      return mockPeople.firstWhere((person) => person.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<PersonModel> getAllPeople() {
    return List.from(mockPeople);
  }

  static List<ImageModel> getPersonImages(int personId) {
    final person = getPersonById(personId);
    if (person == null) return [];

    return person.images.map((url) {
      return ImageModel(
        id: '${personId}_${person.images.indexOf(url)}',
        url: url,
        title: '${person.name} Image ${person.images.indexOf(url) + 1}',
        width: 500,
        height: 750,
        aspectRatio: '2:3',
      );
    }).toList();
  }
}
