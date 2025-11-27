import '../models/index.dart';
import '../database/database_helper.dart';

/// Repository pour les produits
class ProductRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Obtenir tous les produits
  Future<List<Product>> getAllProducts() async {
    return _databaseHelper.getAllProducts();
  }

  /// Obtenir les produits par catégorie
  Future<List<Product>> getProductsByCategory(String category) async {
    return _databaseHelper.getProductsByCategory(category);
  }

  /// Obtenir un produit par ID
  Future<Product?> getProductById(String id) async {
    return _databaseHelper.getProductById(id);
  }

  /// Rechercher des produits
  Future<List<Product>> searchProducts(String query) async {
    return _databaseHelper.searchProducts(query);
  }

  /// Obtenir les produits recommandés (par popularité)
  Future<List<Product>> getRecommendedProducts({int limit = 10}) async {
    final products = await _databaseHelper.getAllProducts();
    products.sort((a, b) => b.popularity.compareTo(a.popularity));
    return products.take(limit).toList();
  }

  /// Obtenir les catégories uniques
  Future<List<String>> getCategories() async {
    final products = await _databaseHelper.getAllProducts();
    final categories = <String>{};
    for (final product in products) {
      categories.add(product.category);
    }
    return categories.toList();
  }

  /// Filtrer les produits par prix
  Future<List<Product>> filterByPrice({
    required double minPrice,
    required double maxPrice,
  }) async {
    final products = await _databaseHelper.getAllProducts();
    return products
        .where((p) => p.price >= minPrice && p.price <= maxPrice)
        .toList();
  }
}
