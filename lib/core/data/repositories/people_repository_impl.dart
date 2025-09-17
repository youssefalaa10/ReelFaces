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

        // Cache the result
        await _cacheService.save('popular_people_page_$page', paginatedPeople);

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

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final personDetails = _parsePersonDetails(data);

        // Cache the result
        await _cacheService.save(
          'person_details_$id',
          personDetails,
          ttlMinutes: 120, // Cache for 2 hours
        );

        _logger.i(
          'Person details fetched from network - id: $id, name: ${personDetails.name}',
        );
        return personDetails;
      } else {
        throw ServerException(
          message: 'Failed to fetch person details: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _logger.w(
        'Network error fetching person details, trying cache - id: $id, error: ${e.message}',
      );

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

        // Cache the result
        await _cacheService.save(
          'person_images_$id',
          images,
          ttlMinutes: 180, // Cache for 3 hours
        );

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

  // Cache fallback methods
  Future<Paginated<Person>> _getCachedPopularPeople(int page) async {
    final cached = await _cacheService.get<Paginated<Person>>(
      'popular_people_page_$page',
      (json) => JsonHelpers.paginatedFromJson(json, JsonHelpers.personFromJson),
    );

    if (cached != null) {
      _logger.i(
        'Popular people retrieved from cache - page: $page, count: ${cached.results.length}',
      );
      return cached;
    }

    throw CacheException(
      message: 'No cached data available for popular people page $page',
    );
  }

  Future<PersonDetails> _getCachedPersonDetails(int id) async {
    final cached = await _cacheService.get<PersonDetails>(
      'person_details_$id',
      JsonHelpers.personDetailsFromJson,
    );

    if (cached != null) {
      _logger.i(
        'Person details retrieved from cache - id: $id, name: ${cached.name}',
      );
      return cached;
    }

    throw CacheException(
      message: 'No cached data available for person details $id',
    );
  }

  Future<List<ProfileImage>> _getCachedPersonImages(int id) async {
    final cached = await _cacheService.getList<ProfileImage>(
      'person_images_$id',
      JsonHelpers.profileImageFromJson,
    );

    if (cached != null) {
      _logger.i(
        'Person images retrieved from cache - id: $id, count: ${cached.length}',
      );
      return cached;
    }

    throw CacheException(
      message: 'No cached data available for person images $id',
    );
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
    return PersonDetails(
      id: data['id'] as int,
      name: data['name'] as String,
      adult: data['adult'] as bool? ?? false,
      alsoKnownAs: (data['also_known_as'] as List?)?.cast<String>() ?? [],
      biography: data['biography'] as String?,
      birthday: data['birthday'] as String?,
      deathday: data['deathday'] as String?,
      placeOfBirth: data['place_of_birth'] as String?,
      profilePath: data['profile_path'] as String?,
      popularity: (data['popularity'] as num?)?.toDouble(),
      knownForDepartment: data['known_for_department'] as String?,
      homepage: data['homepage'] as String?,
    );
  }

  List<ProfileImage> _parseProfileImages(Map<String, dynamic> data) {
    final profiles = data['profiles'] as List? ?? [];
    return profiles
        .map((item) => _parseProfileImage(item as Map<String, dynamic>))
        .toList();
  }

  ProfileImage _parseProfileImage(Map<String, dynamic> data) {
    return ProfileImage(
      aspectRatio: (data['aspect_ratio'] as num).toDouble(),
      height: data['height'] as int,
      filePath: data['file_path'] as String,
      voteAverage: (data['vote_average'] as num).toDouble(),
      voteCount: data['vote_count'] as int,
      width: data['width'] as int,
      iso6391: data['iso_639_1'] as String?,
    );
  }
}
