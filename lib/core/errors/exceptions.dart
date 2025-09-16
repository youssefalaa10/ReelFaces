import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  const AppException({required this.message, this.code, this.details});
  final String message;
  final String? code;
  final dynamic details;

  @override
  List<Object?> get props => [message, code, details];
}

// Network Exceptions
class NetworkException extends AppException {
  const NetworkException({required super.message, super.code, super.details});
}

class ServerException extends AppException {
  const ServerException({required super.message, super.code, super.details});
}

class TimeoutException extends AppException {
  const TimeoutException({required super.message, super.code, super.details});
}

class ConnectionException extends AppException {
  const ConnectionException({
    required super.message,
    super.code,
    super.details,
  });
}

// API Exceptions
class ApiException extends AppException {
  const ApiException({required super.message, super.code, super.details});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    required super.message,
    super.code,
    super.details,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({required super.message, super.code, super.details});
}

class NotFoundException extends AppException {
  const NotFoundException({required super.message, super.code, super.details});
}

class TooManyRequestsException extends AppException {
  const TooManyRequestsException({
    required super.message,
    super.code,
    super.details,
  });
}

class InternalServerErrorException extends AppException {
  const InternalServerErrorException({
    required super.message,
    super.code,
    super.details,
  });
}

// Data Exceptions
class DataException extends AppException {
  const DataException({required super.message, super.code, super.details});
}

class ParsingException extends AppException {
  const ParsingException({required super.message, super.code, super.details});
}

class CacheException extends AppException {
  const CacheException({required super.message, super.code, super.details});
}

// Unknown Exception
class UnknownException extends AppException {
  const UnknownException({required super.message, super.code, super.details});
}
