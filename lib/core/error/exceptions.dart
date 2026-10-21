abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => '$runtimeType: $message';
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

class ValidationException extends AppException {
  final Map<String, List<String>> errors;

  const ValidationException({
    required super.message,
    this.errors = const {},
    super.statusCode = 422,
    super.originalError,
  });
}

class ParsingException extends AppException {
  const ParsingException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}
