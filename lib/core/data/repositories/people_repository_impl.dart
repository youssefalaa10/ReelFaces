import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../db/db.dart';
import '../../domain/entities/paginated.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/person_details.dart';
import '../../domain/entities/profile_image.dart';
import '../../domain/repositories/people_repository.dart';
import '../../errors/exceptions.dart';
import '../../network/network_constants.dart';
import '../../network/network_service.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  PeopleRepositoryImpl({
    required NetworkService networkService,
    required CacheService cacheService,
    Logger? logger,
  }) : _networkService = networkService,
       _cacheService = cacheService,
       _logger = logger ?? Logger();
  final NetworkService _networkService;
  final CacheService _cacheService;
  final Logger _logger;

  @override
  Future<Paginated<Person>> getPopularPeople(int page) async {
    try {
      _logger.d('Fetching popular people - page: $page');

      // Try network first
      final response = await _networkService.dio.get<Map<String, dynamic>>(
        NetworkConstants.popularPeopleEndpoint,
        queryParameters: {NetworkConstants.pageParam: page},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        _logger.d('API Response data keys: ${data.keys.toList()}');
        _logger.d('Results count: ${data['results']?.length ?? 0}');

        final paginatedPeople = _parsePaginatedPeople(data);

        // Cache the result as JSON list with pagination metadata
        await _cachePopularPeoplePage(page, paginatedPeople);

        _logger.i(
          'Popular people fetched from network - page: $page, count: ${paginatedPeople.results.length}',
        );
        return paginatedPeople;
      } else {
        throw ServerException(
          message: 'Failed to fetch popular people: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _logger.w(
        'Network error fetching popular people, trying cache - page: $page, error: ${e.message}',
      );

      // Fallback to cache
      return await _getCachedPopularPeople(page);
    } catch (e) {
      _logger.e(
        'Unexpected error fetching popular people, trying cache - page: $page, error: $e',
      );

      // Fallback to cache
      return await _getCachedPopularPeople(page);
    }
  }

  @override
  Future<PersonDetails> getPersonDetails(int id) async {
    try {
      _logger.d('Fetching person details - id: $id');

      // Try network first
      final response = await _networkService.dio.get<Map<String, dynamic>>(
        '${NetworkConstants.personEndpoint}/$id',
      );

      _logger.d('Person details response status: ${response.statusCode}');
      _logger.d('Person details response headers: ${response.headers}');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        if (data.isEmpty) {
          throw const ServerException(
            message: 'Empty response received for person details',
          );
        }

        final personDetails = _parsePersonDetails(data);

        // Cache the result as JSON
        await _cachePersonDetails(id, personDetails);

        _logger.i(
          'Person details fetched from network - id: $id, name: ${personDetails.name}',
        );
        return personDetails;
      } else {
        throw ServerException(
          message:
              'Failed to fetch person details: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      _logger.e(
        'Network error fetching person details - id: $id, error: ${e.message}',
      );
      _logger.e('DioException type: ${e.type}');
      _logger.e('DioException response: ${e.response?.data}');
      _logger.e('DioException status code: ${e.response?.statusCode}');

      // Fallback to cache
      return await _getCachedPersonDetails(id);
    } catch (e) {
      _logger.e(
        'Unexpected error fetching person details, trying cache - id: $id, error: $e',
      );

      // Fallback to cache
      return await _getCachedPersonDetails(id);
    }
  }

  @override
  Future<List<ProfileImage>> getPersonImages(int id) async {
    try {
      _logger.d('Fetching person images - id: $id');

      // Try network first
      final response = await _networkService.dio.get<Map<String, dynamic>>(
        '${NetworkConstants.personEndpoint}/$id/images',
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final images = _parseProfileImages(data);

        // Cache the result as JSON list
        await _cachePersonImages(id, images);

        _logger.i(
          'Person images fetched from network - id: $id, count: ${images.length}',
        );
        return images;
      } else {
        throw ServerException(
          message: 'Failed to fetch person images: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _logger.w(
        'Network error fetching person images, trying cache - id: $id, error: ${e.message}',
      );

      // Fallback to cache
      return await _getCachedPersonImages(id);
    } catch (e) {
      _logger.e(
        'Unexpected error fetching person images, trying cache - id: $id, error: $e',
      );

      // Fallback to cache
      return await _getCachedPersonImages(id);
    }
  }

  // Cache helper methods
  Future<void> _cachePopularPeoplePage(
    int page,
    Paginated<Person> paginatedPeople,
  ) async {
    try {
      // Convert people to JSON list
      final peopleJsonList = paginatedPeople.results
          .map((person) => JsonHelpers.personToJson(person))
          .toList();

      // Store people list
      await _cacheService.save('popular_people_page_$page', peopleJsonList);

      // Store pagination metadata separately
      final metadata = {
        'page': paginatedPeople.page,
        'totalPages': paginatedPeople.totalPages,
        'totalResults': paginatedPeople.totalResults,
      };
      await _cacheService.save('popular_people_metadata_$page', metadata);

      _logger.d(
        'Cached popular people page $page with ${peopleJsonList.length} people',
      );
    } catch (e) {
      _logger.e('Error caching popular people page $page: $e');
      // Don't throw here, just log the error
    }
  }

  // Cache fallback methods
  Future<Paginated<Person>> _getCachedPopularPeople(int page) async {
    try {
      // Get cached people list
      final cachedPeopleList = await _cacheService
          .getList<Map<String, dynamic>>(
            'popular_people_page_$page',
            (json) => json,
          );

      // Get cached pagination metadata
      final cachedMetadata = await _cacheService.get<Map<String, dynamic>>(
        'popular_people_metadata_$page',
        (json) => json,
      );

      if (cachedPeopleList != null && cachedMetadata != null) {
        // Convert JSON list back to Person objects
        final people = cachedPeopleList
            .map((json) => JsonHelpers.personFromJson(json))
            .toList();

        // Reconstruct Paginated object
        final paginatedPeople = Paginated<Person>(
          page: cachedMetadata['page'] as int,
          results: people,
          totalPages: cachedMetadata['totalPages'] as int,
          totalResults: cachedMetadata['totalResults'] as int,
        );

        _logger.i(
          'Popular people retrieved from cache - page: $page, count: ${people.length}',
        );
        return paginatedPeople;
      }

      throw CacheException(
        message: 'No cached data available for popular people page $page',
      );
    } catch (e) {
      _logger.e('Error retrieving cached popular people: $e');
      throw CacheException(
        message: 'No cached data available for popular people page $page',
      );
    }
  }

  Future<void> _cachePersonDetails(int id, PersonDetails personDetails) async {
    try {
      // Convert PersonDetails to JSON using built-in method
      final personDetailsJson = personDetails.toJson();

      // Store as JSON
      await _cacheService.save(
        'person_details_$id',
        personDetailsJson,
        ttlMinutes: 120, // Cache for 2 hours
      );

      _logger.d('Person details cached for $id: ${personDetails.name}');
    } catch (e) {
      _logger.e('Failed to cache person details for $id: $e');
    }
  }

  Future<PersonDetails> _getCachedPersonDetails(int id) async {
    try {
      // Get cached JSON data
      final cachedJson = await _cacheService.get<Map<String, dynamic>>(
        'person_details_$id',
        (json) => json,
      );

      if (cachedJson != null) {
        // Convert JSON back to PersonDetails using built-in method
        final personDetails = PersonDetails.fromJson(cachedJson);

        _logger.i(
          'Person details retrieved from cache - id: $id, name: ${personDetails.name}',
        );
        return personDetails;
      }

      throw CacheException(
        message: 'No cached data available for person details $id',
      );
    } catch (e) {
      _logger.e('Error retrieving cached person details: $e');
      throw CacheException(
        message: 'No cached data available for person details $id',
      );
    }
  }

  Future<void> _cachePersonImages(int id, List<ProfileImage> images) async {
    try {
      // Convert images to JSON list
      final imagesJsonList = images
          .map((image) => JsonHelpers.profileImageToJson(image))
          .toList();

      // Store images list
      await _cacheService.save(
        'person_images_$id',
        imagesJsonList,
        ttlMinutes: 180, // Cache for 3 hours
      );

      _logger.d(
        'Person images cached for $id with ${imagesJsonList.length} images',
      );
    } catch (e) {
      _logger.e('Failed to cache person images for $id: $e');
    }
  }

  Future<List<ProfileImage>> _getCachedPersonImages(int id) async {
    try {
      // Get cached images list as JSON
      final cachedImagesList = await _cacheService
          .getList<Map<String, dynamic>>('person_images_$id', (json) => json);

      if (cachedImagesList != null) {
        // Convert JSON list back to ProfileImage objects
        final images = cachedImagesList
            .map((json) => JsonHelpers.profileImageFromJson(json))
            .toList();

        _logger.i(
          'Person images retrieved from cache - id: $id, count: ${images.length}',
        );
        return images;
      }

      throw CacheException(
        message: 'No cached data available for person images $id',
      );
    } catch (e) {
      _logger.e('Error retrieving cached person images: $e');
      throw CacheException(
        message: 'No cached data available for person images $id',
      );
    }
  }

  // Parsing methods
  Paginated<Person> _parsePaginatedPeople(Map<String, dynamic> data) {
    try {
      _logger.d('Parsing paginated people data...');
      _logger.d(
        'Page: ${data['page']}, Total pages: ${data['total_pages']}, Total results: ${data['total_results']}',
      );

      final results = (data['results'] as List).map((item) {
        _logger.d('Parsing person: ${item['name']} (ID: ${item['id']})');
        return _parsePerson(item as Map<String, dynamic>);
      }).toList();

      _logger.d('Successfully parsed ${results.length} people');

      return Paginated<Person>(
        page: data['page'] as int,
        results: results,
        totalPages: data['total_pages'] as int,
        totalResults: data['total_results'] as int,
      );
    } catch (e, stackTrace) {
      _logger.e('Error parsing paginated people: $e');
      _logger.e('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Person _parsePerson(Map<String, dynamic> data) {
    try {
      // Parse known_for as list of movie/TV show IDs
      List<int> knownForIds = [];
      if (data['known_for'] != null) {
        final knownForList = data['known_for'] as List;
        knownForIds = knownForList
            .where((item) => item is Map<String, dynamic> && item['id'] != null)
            .map((item) => item['id'] as int)
            .toList();
      }

      final person = Person(
        id: data['id'] as int,
        name: data['name'] as String,
        adult: data['adult'] as bool? ?? false,
        knownFor: knownForIds,
        profilePath: data['profile_path'] as String?,
        popularity: (data['popularity'] as num?)?.toDouble(),
      );

      _logger.d(
        'Parsed person: ${person.name} (ID: ${person.id}, Known for: ${person.knownFor.length} items)',
      );
      return person;
    } catch (e, stackTrace) {
      _logger.e('Error parsing person: $e');
      _logger.e('Data: $data');
      _logger.e('Stack trace: $stackTrace');
      rethrow;
    }
  }

  PersonDetails _parsePersonDetails(Map<String, dynamic> data) {
    try {
      _logger.d('Parsing person details data...');
      _logger.d('Data keys: ${data.keys.toList()}');

      // Safely parse also_known_as list
      List<String> alsoKnownAs = [];
      if (data['also_known_as'] != null && data['also_known_as'] is List) {
        final alsoKnownAsList = data['also_known_as'] as List;
        alsoKnownAs = alsoKnownAsList
            .where((item) => item != null && item is String)
            .cast<String>()
            .toList();
      }

      final personDetails = PersonDetails(
        id: data['id'] as int? ?? 0,
        name: data['name'] as String? ?? 'Unknown',
        adult: data['adult'] as bool? ?? false,
        alsoKnownAs: alsoKnownAs,
        biography: data['biography'] as String?,
        birthday: data['birthday'] as String?,
        deathday: data['deathday'] as String?,
        placeOfBirth: data['place_of_birth'] as String?,
        profilePath: data['profile_path'] as String?,
        popularity: (data['popularity'] as num?)?.toDouble(),
        knownForDepartment: data['known_for_department'] as String?,
        homepage: data['homepage'] as String?,
      );

      _logger.d(
        'Successfully parsed person details: ${personDetails.name} (ID: ${personDetails.id})',
      );
      return personDetails;
    } catch (e, stackTrace) {
      _logger.e('Error parsing person details: $e');
      _logger.e('Data: $data');
      _logger.e('Stack trace: $stackTrace');
      rethrow;
    }
  }

  List<ProfileImage> _parseProfileImages(Map<String, dynamic> data) {
    final profiles = data['profiles'] as List? ?? [];
    return profiles
        .map((item) => _parseProfileImage(item as Map<String, dynamic>))
        .toList();
  }

  ProfileImage _parseProfileImage(Map<String, dynamic> data) {
    final filePath = data['file_path'] as String;
    // Don't construct full URL here - let ImageTile handle it
    // The filePath should be used with NetworkConfig.getProfileImageUrl()

    return ProfileImage(
      aspectRatio: (data['aspect_ratio'] as num).toDouble(),
      height: data['height'] as int,
      filePath: filePath, // Store just the file path
      voteAverage: (data['vote_average'] as num).toDouble(),
      voteCount: data['vote_count'] as int,
      width: data['width'] as int,
      iso6391: data['iso_639_1'] as String?,
    );
  }
}
