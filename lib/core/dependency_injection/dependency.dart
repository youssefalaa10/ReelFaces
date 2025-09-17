import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../features/home/logic/popular_people_cubit.dart';
import '../../features/image_viewer/logic/image_save_cubit.dart';
import '../../features/person_details/logic/person_details_cubit.dart';
import '../../features/person_details/logic/person_images_cubit.dart';
import '../config/env_config.dart';
import '../data/repositories/people_repository_impl.dart';
import '../db/db.dart';
import '../db/hive_service.dart';
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

  // Register cache service (using the one from HiveService)
  getIt.registerLazySingleton<CacheService>(() => HiveService().cacheService);

  // Register repositories
  getIt.registerLazySingleton<PeopleRepository>(
    () => PeopleRepositoryImpl(
      networkService: getIt<NetworkService>(),
      cacheService: getIt<CacheService>(),
      logger: getIt<Logger>(),
    ),
  );

  // Register cubits
  getIt.registerFactory<PopularPeopleCubit>(
    () => PopularPeopleCubit(
      peopleRepository: getIt<PeopleRepository>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerFactory<PersonDetailsCubit>(
    () => PersonDetailsCubit(
      peopleRepository: getIt<PeopleRepository>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerFactory<PersonImagesCubit>(
    () => PersonImagesCubit(
      peopleRepository: getIt<PeopleRepository>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerFactory<ImageSaveCubit>(
    () => ImageSaveCubit(logger: getIt<Logger>()),
  );
}
