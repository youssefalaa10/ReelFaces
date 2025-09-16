import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'adapters/person_adapter.dart';
import 'adapters/person_details_adapter.dart';
import 'adapters/profile_image_adapter.dart';
import 'cache_service.dart';

class HiveService {
  factory HiveService() => _instance;
  HiveService._internal();
  static final HiveService _instance = HiveService._internal();

  final Logger _logger = Logger();
  late CacheService _cacheService;

  /// Get the cache service instance
  CacheService get cacheService => _cacheService;

  /// Initialize Hive and register adapters
  Future<void> initialize() async {
    try {
      // Initialize Hive
      await Hive.initFlutter();

      // Register adapters
      Hive.registerAdapter(PersonAdapter());
      Hive.registerAdapter(PersonDetailsAdapter());
      Hive.registerAdapter(ProfileImageAdapter());

      // Initialize cache service
      _cacheService = CacheService();
      await _cacheService.initialize();

      // Clear expired entries on startup
      await _cacheService.clearExpired();

      _logger.i('Hive service initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize Hive service: $e');
      rethrow;
    }
  }

  /// Close Hive service
  Future<void> close() async {
    try {
      await _cacheService.close();
      await Hive.close();
      _logger.i('Hive service closed');
    } catch (e) {
      _logger.e('Failed to close Hive service: $e');
    }
  }
}
