class NetworkConstants {
  // TMDb API Configuration
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
  
  // API Version
  static const String apiVersion = '3';
  
  // Endpoints
  static const String personEndpoint = '/person';
  static const String popularPeopleEndpoint = '/person/popular';
  static const String personImagesEndpoint = '/person/{person_id}/images';
  static const String searchPeopleEndpoint = '/search/person';
  
  // Query Parameters
  static const String apiKeyParam = 'api_key';
  static const String languageParam = 'language';
  static const String pageParam = 'page';
  static const String queryParam = 'query';
  
  // Default Values
  static const String defaultLanguage = 'en-US';
  static const int defaultPage = 1;
  static const int defaultPageSize = 20;
  
  // Image Sizes
  static const String profileSizeSmall = 'w185';
  static const String profileSizeMedium = 'w342';
  static const String profileSizeLarge = 'w500';
  static const String profileSizeOriginal = 'original';
  
  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
  
  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';
  static const String authorizationHeader = 'Authorization';
  static const String userAgentHeader = 'User-Agent';
  
  // Content Types
  static const String applicationJson = 'application/json';
  static const String applicationFormUrlEncoded = 'application/x-www-form-urlencoded';
  
  // User Agent
  static const String userAgent = 'ReelFaces/1.0.0 (Flutter)';
}
