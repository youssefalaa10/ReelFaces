import 'package:dio/dio.dart';

import '../network_constants.dart';

class ApiKeyInterceptor extends Interceptor {
  ApiKeyInterceptor({
    required this.apiKey,
    this.accessToken,
    this.language = NetworkConstants.defaultLanguage,
  });
  final String apiKey;
  final String? accessToken;
  final String language;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add API key to query parameters
    options.queryParameters[NetworkConstants.apiKeyParam] = apiKey;

    // Add access token as Bearer token if provided
    if (accessToken != null && accessToken!.isNotEmpty) {
      options.headers[NetworkConstants.authorizationHeader] =
          'Bearer $accessToken';
    }

    // Add language parameter
    options.queryParameters[NetworkConstants.languageParam] = language;

    // Add default headers
    options.headers[NetworkConstants.contentTypeHeader] =
        NetworkConstants.applicationJson;
    options.headers[NetworkConstants.acceptHeader] =
        NetworkConstants.applicationJson;
    options.headers[NetworkConstants.userAgentHeader] =
        NetworkConstants.userAgent;

    super.onRequest(options, handler);
  }
}
