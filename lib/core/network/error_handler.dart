import 'package:dio/dio.dart';

import '../errors/failures.dart';

class NetworkErrorHandler {
  static Failure handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          message: 'Request timeout. Please check your internet connection.',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return ConnectionFailure(
          message: 'No internet connection. Please check your network settings.',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return NetworkFailure(
          message: 'Request was cancelled.',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.unknown:
      default:
        return UnknownFailure(
          message: error.message ?? 'An unknown error occurred.',
          statusCode: error.response?.statusCode,
        );
    }
  }

  static Failure _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = _getErrorMessage(error);

    switch (statusCode) {
      case 400:
        return ApiFailure(
          message: message,
          statusCode: statusCode,
          errorCode: 'BAD_REQUEST',
        );

      case 401:
        return UnauthorizedFailure(
          message: 'Unauthorized. Please check your API key.',
          statusCode: statusCode,
          errorCode: 'UNAUTHORIZED',
        );

      case 403:
        return ForbiddenFailure(
          message: 'Forbidden. You do not have permission to access this resource.',
          statusCode: statusCode,
          errorCode: 'FORBIDDEN',
        );

      case 404:
        return NotFoundFailure(
          message: 'Resource not found.',
          statusCode: statusCode,
          errorCode: 'NOT_FOUND',
        );

      case 429:
        return TooManyRequestsFailure(
          message: 'Too many requests. Please try again later.',
          statusCode: statusCode,
          errorCode: 'TOO_MANY_REQUESTS',
        );

      case 500:
        return InternalServerErrorFailure(
          message: 'Internal server error. Please try again later.',
          statusCode: statusCode,
          errorCode: 'INTERNAL_SERVER_ERROR',
        );

      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message: 'Server is temporarily unavailable. Please try again later.',
          statusCode: statusCode,
          errorCode: 'SERVER_ERROR',
        );

      default:
        return ApiFailure(
          message: message,
          statusCode: statusCode,
          errorCode: 'API_ERROR',
        );
    }
  }

  static String _getErrorMessage(DioException error) {
    try {
      final responseData = error.response?.data;
      
      if (responseData is Map<String, dynamic>) {
        // TMDb API error format
        if (responseData.containsKey('status_message')) {
          return responseData['status_message'] as String;
        }
        
        if (responseData.containsKey('message')) {
          return responseData['message'] as String;
        }
        
        if (responseData.containsKey('error')) {
          return responseData['error'] as String;
        }
      }
      
      return error.message ?? 'An error occurred while processing your request.';
    } catch (e) {
      return error.message ?? 'An error occurred while processing your request.';
    }
  }

  static Failure handleParsingError(String message) {
    return ParsingFailure(
      message: 'Failed to parse response: $message',
    );
  }

  static Failure handleCacheError(String message) {
    return CacheFailure(
      message: 'Cache error: $message',
    );
  }

  static Failure handleDataError(String message) {
    return DataFailure(
      message: 'Data error: $message',
    );
  }
}
