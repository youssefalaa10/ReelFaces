import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'dio_client.dart';
import 'network_constants.dart';

class NetworkService {
  NetworkService._({
    required this.apiKey,
    this.accessToken,
    this.language = NetworkConstants.defaultLanguage,
    this.logger,
  });

  factory NetworkService({
    required String apiKey,
    String? accessToken,
    String language = NetworkConstants.defaultLanguage,
    Logger? logger,
  }) {
    _instance ??= NetworkService._(
      apiKey: apiKey,
      accessToken: accessToken,
      language: language,
      logger: logger,
    );
    return _instance!;
  }
  static NetworkService? _instance;
  static DioClient? _dioClient;

  final String apiKey;
  final String? accessToken;
  final String language;
  final Logger? logger;

  static NetworkService get instance {
    if (_instance == null) {
      throw Exception(
        'NetworkService not initialized. Call NetworkService() first.',
      );
    }
    return _instance!;
  }

  DioClient get dioClient {
    _dioClient ??= DioClient(
      apiKey: apiKey,
      accessToken: accessToken,
      language: language,
      logger: logger,
    );
    return _dioClient!;
  }

  // Convenience getter for direct Dio access
  Dio get dio => dioClient.dio;

  // Method to update API key
  void updateApiKey(String newApiKey) {
    dioClient.updateApiKey(newApiKey);
  }

  // Method to update language
  void updateLanguage(String newLanguage) {
    dioClient.updateLanguage(newLanguage);
  }

  // Method to reset the service
  static void reset() {
    _dioClient?.dispose();
    _dioClient = null;
    _instance = null;
  }

  // Dispose method
  void dispose() {
    dioClient.dispose();
  }
}
