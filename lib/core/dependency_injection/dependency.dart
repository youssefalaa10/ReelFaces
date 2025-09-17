import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../config/env_config.dart';
import '../data/repositories/people_repository_impl.dart';
import '../db/db.dart';
import '../domain/repositories/people_repository.dart';
import '../network/network_service.dart';

final getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  // Initialize environment variables
  await EnvConfig.initialize();

  // Validate environment configuration
  if (!EnvConfig.isConfigValid) {
    throw Exception(
      'Environment configuration is invalid. Please check your .env file.',
    );
  }

  // Register services
  getIt.registerLazySingleton<Logger>(() => Logger());

  getIt.registerLazySingleton<NetworkService>(
    () => NetworkService(
      apiKey: EnvConfig.apiKey,
      accessToken: EnvConfig.accessToken,
      language: EnvConfig.defaultLanguage,
      logger: getIt<Logger>(),
    ),
  );

  // Register cache service
  getIt.registerLazySingleton<CacheService>(() => CacheService());

  // Register repositories
  getIt.registerLazySingleton<PeopleRepository>(
    () => PeopleRepositoryImpl(
      networkService: getIt<NetworkService>(),
      cacheService: getIt<CacheService>(),
      logger: getIt<Logger>(),
    ),
  );
}
