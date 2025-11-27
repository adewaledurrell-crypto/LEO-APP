/// Classe d'exception personnalisée pour l'application
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.code,
    this.originalException,
    this.stackTrace,
  });

  @override
  String toString() {
    if (code != null) {
      return 'AppException [$code]: $message';
    }
    return 'AppException: $message';
  }
}

/// Exception de réseau
class NetworkException extends AppException {
  NetworkException({
    String message = 'Network error occurred',
    String? code,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         code: code ?? 'NETWORK_ERROR',
         originalException: originalException,
         stackTrace: stackTrace,
       );
}

/// Exception de validation
class ValidationException extends AppException {
  ValidationException({
    String message = 'Validation error',
    String? code,
  }) : super(
         message: message,
         code: code ?? 'VALIDATION_ERROR',
       );
}

/// Exception de base de données
class DatabaseException extends AppException {
  DatabaseException({
    String message = 'Database error',
    String? code,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         code: code ?? 'DATABASE_ERROR',
         originalException: originalException,
         stackTrace: stackTrace,
       );
}

/// Exception d'authentification
class AuthException extends AppException {
  AuthException({
    String message = 'Authentication error',
    String? code,
  }) : super(
         message: message,
         code: code ?? 'AUTH_ERROR',
       );
}

/// Exception de timeout
class TimeoutException extends AppException {
  TimeoutException({
    String message = 'Request timeout',
    String? code,
  }) : super(
         message: message,
         code: code ?? 'TIMEOUT_ERROR',
       );
}

/// Exception non trouvée
class NotFoundException extends AppException {
  NotFoundException({
    String message = 'Resource not found',
    String? code,
  }) : super(
         message: message,
         code: code ?? 'NOT_FOUND',
       );
}

/// Exception serveur
class ServerException extends AppException {
  ServerException({
    String message = 'Server error',
    String? code,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         code: code ?? 'SERVER_ERROR',
         originalException: originalException,
         stackTrace: stackTrace,
       );
}
