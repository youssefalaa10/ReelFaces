import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'error_handler.dart';
import 'interceptors/api_key_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'network_constants.dart';

class DioClient {
  DioClient({
    required this.apiKey,
    this.accessToken,
    this.language = NetworkConstants.defaultLanguage,
    this.logger,
  }) {
    _dio = _createDio();
  }
  final String apiKey;
  final String? accessToken;
  final String language;
  final Logger? logger;
  late final Dio _dio;

  Dio get dio => _dio;

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: NetworkConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: NetworkConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: NetworkConstants.receiveTimeout,
        ),
        sendTimeout: const Duration(milliseconds: NetworkConstants.sendTimeout),
        headers: {
          NetworkConstants.contentTypeHeader: NetworkConstants.applicationJson,
          NetworkConstants.acceptHeader: NetworkConstants.applicationJson,
          NetworkConstants.userAgentHeader: NetworkConstants.userAgent,
        },
      ),
    );

    // Add interceptors
    _addInterceptors(dio);

    return dio;
  }

  void _addInterceptors(Dio dio) {
    // API Key Interceptor 
    dio.interceptors.add(
      ApiKeyInterceptor(
        apiKey: apiKey,
        accessToken: accessToken,
        language: language,
      ),
    );

    // Logging Interceptor
    dio.interceptors.add(LoggingInterceptor(logger: logger));

    // Error Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Error handling is done in the convenience methods
          handler.next(error);
        },
      ),
    );
  }

  // Convenience methods for common HTTP operations
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkErrorHandler.handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkErrorHandler.handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkErrorHandler.handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkErrorHandler.handleDioError(e);
    }
  }

  // Method to update API key
  void updateApiKey(String newApiKey) {
    // Remove old API key interceptor
    _dio.interceptors.removeWhere(
      (interceptor) => interceptor is ApiKeyInterceptor,
    );

    // Add new API key interceptor
    _dio.interceptors.insert(
      0,
      ApiKeyInterceptor(
        apiKey: newApiKey,
        accessToken: accessToken,
        language: language,
      ),
    );
  }

  // Method to update language
  void updateLanguage(String newLanguage) {
    // Remove old API key interceptor
    _dio.interceptors.removeWhere(
      (interceptor) => interceptor is ApiKeyInterceptor,
    );

    // Add new API key interceptor with updated language
    _dio.interceptors.insert(
      0,
      ApiKeyInterceptor(
        apiKey: apiKey,
        accessToken: accessToken,
        language: newLanguage,
      ),
    );
  }

  // Method to clear all interceptors
  void clearInterceptors() {
    _dio.interceptors.clear();
  }

  // Method to add custom interceptor
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  // Method to remove specific interceptor
  void removeInterceptor(Interceptor interceptor) {
    _dio.interceptors.remove(interceptor);
  }

  // Dispose method
  void dispose() {
    _dio.close();
  }
}
