class AppException implements Exception {

  const AppException({required this.message, this.code, this.originalError});
  final String message;
  final String? code;
  final dynamic originalError;

  @override
  String toString() => 'AppException($code): $message';
}

class NetworkException extends AppException {

  const NetworkException({required super.message, this.statusCode, super.code, super.originalError});
  final int? statusCode;

  @override
  String toString() => 'NetworkException($statusCode): $message';
}

class AuthException extends AppException {
  const AuthException({required super.message, super.code, super.originalError});
}

class SyncException extends AppException {
  const SyncException({required super.message, super.code, super.originalError});
}
