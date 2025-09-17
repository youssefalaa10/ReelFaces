import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Debug interceptor to help troubleshoot API authentication issues
class DebugInterceptor extends Interceptor {
  DebugInterceptor({Logger? logger}) : _logger = logger ?? Logger();
  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d('DEBUG REQUEST:');
    _logger.d('  Method: ${options.method}');
    _logger.d('  URL: ${options.uri}');
    _logger.d('  Headers: ${options.headers}');
    _logger.d('  Query Parameters: ${options.queryParameters}');

    // Check if API key is present
    final hasApiKey =
        options.queryParameters.containsKey('api_key') ||
        options.headers.containsKey('Authorization');
    _logger.d('  Has Authentication: $hasApiKey');

    if (options.queryParameters.containsKey('api_key')) {
      final apiKey = options.queryParameters['api_key'] as String;
      _logger.d('  API Key: ${apiKey.substring(0, 8)}...');
    }

    if (options.headers.containsKey('Authorization')) {
      final auth = options.headers['Authorization'] as String;
      _logger.d('  Authorization: ${auth.substring(0, 20)}...');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _logger.d(' DEBUG RESPONSE:');
    _logger.d('  Status: ${response.statusCode}');
    _logger.d('  URL: ${response.requestOptions.uri}');
    _logger.d('  Headers: ${response.headers}');

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      _logger.d('  Response Keys: ${data.keys.toList()}');

      // Check for common error fields
      if (data.containsKey('status_message')) {
        _logger.w('  Status Message: ${data['status_message']}');
      }
      if (data.containsKey('success')) {
        _logger.d('  Success: ${data['success']}');
      }
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('DEBUG ERROR:');
    _logger.e('  Status: ${err.response?.statusCode}');
    _logger.e('  URL: ${err.requestOptions.uri}');
    _logger.e('  Message: ${err.message}');
    _logger.e('  Type: ${err.type}');

    if (err.response?.data != null) {
      _logger.e('  Response Data: ${err.response?.data}');
    }

    if (err.response?.headers != null) {
      _logger.e('  Response Headers: ${err.response?.headers}');
    }

    super.onError(err, handler);
  }
}
