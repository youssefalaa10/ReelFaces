import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({
    Logger? logger,
    this.logRequestHeaders = true,
    this.logResponseHeaders = false,
    this.logRequestBody = true,
    this.logResponseBody = true,
  }) : _logger = logger ?? Logger();
  final Logger _logger;
  final bool logRequestHeaders;
  final bool logResponseHeaders;
  final bool logRequestBody;
  final bool logResponseBody;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');

    if (logRequestHeaders && options.headers.isNotEmpty) {
      _logger.d('Headers: ${options.headers}');
    }

    if (logRequestBody && options.data != null) {
      _logger.d('Data: ${options.data}');
    }

    if (options.queryParameters.isNotEmpty) {
      _logger.d('Query Parameters: ${options.queryParameters}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.i(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );

    if (logResponseHeaders && response.headers.map.isNotEmpty) {
      _logger.d('Headers: ${response.headers.map}');
    }

    if (logResponseBody && response.data != null) {
      _logger.d('Data: ${response.data}');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    _logger.e('Error: ${err.message}');

    if (err.response?.data != null) {
      _logger.e('Response Data: ${err.response?.data}');
    }

    if (err.response?.headers.map.isNotEmpty == true) {
      _logger.e('Response Headers: ${err.response?.headers.map}');
    }

    super.onError(err, handler);
  }
}
