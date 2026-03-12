class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({required this.message, this.code, this.originalError});

  @override
  String toString() => 'AppException($code): $message';
}

class NetworkException extends AppException {
  final int? statusCode;

  const NetworkException({required super.message, this.statusCode, super.code, super.originalError});

  @override
  String toString() => 'NetworkException($statusCode): $message';
}

class AuthException extends AppException {
  const AuthException({required super.message, super.code, super.originalError});
}

class SyncException extends AppException {
  const SyncException({required super.message, super.code, super.originalError});
}
