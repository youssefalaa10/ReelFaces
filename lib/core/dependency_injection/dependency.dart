import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../config/env_config.dart';
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
}
