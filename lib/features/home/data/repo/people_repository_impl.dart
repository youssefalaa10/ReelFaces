import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../../core/db/db.dart';
import '../../../../core/domain/entities/paginated.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_constants.dart';
import '../../../../core/network/network_service.dart';
import '../../domain/entities/person.dart';
import '../../domain/repositories/people_repository.dart';

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

  // Cache fallback method
  Future<Paginated<Person>> _getCachedPopularPeople(int page) async {
    final cached = await _cacheService.get<Paginated<Person>>(
      'popular_people_page_$page',
      (json) => _parsePaginatedPeople(json),
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

  // Parsing methods
  Paginated<Person> _parsePaginatedPeople(Map<String, dynamic> data) {
    return Paginated<Person>(
      page: data['page'] as int,
      results: (data['results'] as List)
          .map((item) => _parsePerson(item as Map<String, dynamic>))
          .toList(),
      totalPages: data['total_pages'] as int,
      totalResults: data['total_results'] as int,
    );
  }

  Person _parsePerson(Map<String, dynamic> data) {
    return Person(
      id: data['id'] as int,
      name: data['name'] as String,
      adult: data['adult'] as bool? ?? false,
      knownFor: (data['known_for'] as List?)?.cast<int>() ?? [],
      profilePath: data['profile_path'] as String?,
      popularity: (data['popularity'] as num?)?.toDouble(),
    );
  }
}
