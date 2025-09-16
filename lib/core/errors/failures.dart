import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message, this.statusCode, this.errorCode});
  final String message;
  final int? statusCode;
  final String? errorCode;

  @override
  List<Object?> get props => [message, statusCode, errorCode];
}

// Network Failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

// API Specific Failures
class ApiFailure extends Failure {
  const ApiFailure({required super.message, super.statusCode, super.errorCode});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

class InternalServerErrorFailure extends Failure {
  const InternalServerErrorFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

// Data Failures
class DataFailure extends Failure {
  const DataFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

class ParsingFailure extends Failure {
  const ParsingFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

// Unknown Failure
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}
