/// Constantes globales de l'application
class AppConstants {
  // App Info
  static const String appName = 'WaowoShop';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.waowoshop.waowo_shop';

  // Timings
  static const Duration snackBarDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // Pagination
  static const int pageSize = 20;
  static const int initialPage = 1;

  // Pricing
  static const double minPrice = 0.0;
  static const double maxPrice = 10000.0;
  static const double shippingCost = 0.0; // Livraison gratuite
  static const double taxRate = 0.0; // Pas de taxe pour la démo

  // Validation
  static const int minPasswordLength = 6;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;

  // Catégories
  static const List<String> defaultCategories = [
    'All',
    'Electronics',
    'Computers',
    'Tablets',
    'Wearables',
    'Accessories',
    'Storage',
    'Furniture',
  ];

  // Messages d'erreur
  static const String errorNetwork = 'Network error. Please try again.';
  static const String errorUnknown = 'An unknown error occurred.';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorValidation = 'Please check your input.';

  // Messages de succès
  static const String successLogin = 'Login successful!';
  static const String successSignup = 'Account created successfully!';
  static const String successAddToCart = 'Added to cart';
  static const String successOrderPlaced = 'Order placed successfully!';
  static const String successProfileUpdated = 'Profile updated successfully!';

  // Débug
  static const bool isDebugMode = true;
}
