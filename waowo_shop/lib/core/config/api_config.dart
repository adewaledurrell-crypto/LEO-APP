/// Configuration de l'API
class ApiConfig {
  // Base URL pour les appels API (à utiliser pour l'extension future)
  static const String baseUrl = 'https://api.waowoshop.com/api';

  // Endpoints
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String productsEndpoint = '/products';
  static const String ordersEndpoint = '/orders';
  static const String cartEndpoint = '/cart';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers par défaut
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Construire une URL complète
  static String buildUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }

  /// Construire une URL avec des paramètres
  static String buildUrlWithParams(
    String endpoint,
    Map<String, dynamic> params,
  ) {
    final uri = Uri.parse('$baseUrl$endpoint');
    final queryParams = params.map(
      (key, value) => MapEntry(key, value.toString()),
    );
    return uri.replace(queryParameters: queryParams).toString();
  }
}
