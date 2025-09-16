import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static const String _apiKeyKey = 'TMDB_API_KEY';
  static const String _accessTokenKey = 'TMDB_ACCESS_TOKEN';
  static const String _defaultLanguageKey = 'DEFAULT_LANGUAGE';

  // Getters for environment variables
  static String get apiKey {
    final key = dotenv.env[_apiKeyKey];
    if (key == null || key.isEmpty) {
      throw Exception('TMDB_API_KEY not found in environment variables');
    }
    return key;
  }

  static String get accessToken {
    final token = dotenv.env[_accessTokenKey];
    if (token == null || token.isEmpty) {
      throw Exception('TMDB_ACCESS_TOKEN not found in environment variables');
    }
    return token;
  }

  static String get defaultLanguage {
    return dotenv.env[_defaultLanguageKey] ?? 'en-US';
  }

  // Validation methods
  static bool get isApiKeyValid {
    final key = dotenv.env[_apiKeyKey];
    return key != null && key.isNotEmpty;
  }

  static bool get isAccessTokenValid {
    final token = dotenv.env[_accessTokenKey];
    return token != null && token.isNotEmpty;
  }

  static bool get isConfigValid {
    return isApiKeyValid && isAccessTokenValid;
  }

  // Initialize dotenv
  static Future<void> initialize() async {
    await dotenv.load();
  }
}
