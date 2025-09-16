import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../../core/db/db.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_constants.dart';
import '../../../../core/network/network_service.dart';
import '../../domain/entities/profile_image.dart';
import '../../domain/repositories/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  ImageRepositoryImpl({
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
  Future<List<ProfileImage>> getPersonImages(int personId) async {
    try {
      _logger.d('Fetching person images - personId: $personId');

      // Try network first
      final response = await _networkService.dio.get<Map<String, dynamic>>(
        '${NetworkConstants.personEndpoint}/$personId/images',
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final images = _parseProfileImages(data);

        // Cache the result
        await _cacheService.save(
          'person_images_$personId',
          images,
          ttlMinutes: 180, // Cache for 3 hours
        );

        _logger.i(
          'Person images fetched from network - personId: $personId, count: ${images.length}',
        );
        return images;
      } else {
        throw ServerException(
          message: 'Failed to fetch person images: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _logger.w(
        'Network error fetching person images, trying cache - personId: $personId, error: ${e.message}',
      );

      // Fallback to cache
      return await _getCachedPersonImages(personId);
    } catch (e) {
      _logger.e(
        'Unexpected error fetching person images, trying cache - personId: $personId, error: $e',
      );

      // Fallback to cache
      return await _getCachedPersonImages(personId);
    }
  }

  // Cache fallback method
  Future<List<ProfileImage>> _getCachedPersonImages(int personId) async {
    final cached = await _cacheService.getList<ProfileImage>(
      'person_images_$personId',
      _parseProfileImage,
    );

    if (cached != null) {
      _logger.i(
        'Person images retrieved from cache - personId: $personId, count: ${cached.length}',
      );
      return cached;
    }

    throw CacheException(
      message: 'No cached data available for person images $personId',
    );
  }

  // Parsing methods
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
