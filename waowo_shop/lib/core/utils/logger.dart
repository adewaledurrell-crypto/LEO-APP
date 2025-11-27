import '../config/app_constants.dart';

/// Énumération des niveaux de log
enum LogLevel { debug, info, warning, error, success }

/// Classe utilitaire pour les logs
class Logger {
  static const String _prefix = '[WaowoShop]';

  /// Logger un message de debug
  static void debug(String message) {
    if (AppConstants.isDebugMode) {
      print('$_prefix [DEBUG] $message');
    }
  }

  /// Logger un message d'information
  static void info(String message) {
    print('$_prefix [INFO] $message');
  }

  /// Logger un message d'avertissement
  static void warning(String message) {
    print('$_prefix [WARNING] $message');
  }

  /// Logger un message d'erreur
  static void error(String message, [dynamic exception, StackTrace? stackTrace]) {
    print('$_prefix [ERROR] $message');
    if (exception != null) {
      print('Exception: $exception');
    }
    if (stackTrace != null && AppConstants.isDebugMode) {
      print('StackTrace: $stackTrace');
    }
  }

  /// Logger un message de succès
  static void success(String message) {
    print('$_prefix [SUCCESS] ✓ $message');
  }

  /// Logger avec niveau personnalisé
  static void log(String message, {LogLevel level = LogLevel.info}) {
    switch (level) {
      case LogLevel.debug:
        debug(message);
        break;
      case LogLevel.info:
        info(message);
        break;
      case LogLevel.warning:
        warning(message);
        break;
      case LogLevel.error:
        error(message);
        break;
      case LogLevel.success:
        success(message);
        break;
    }
  }
}
