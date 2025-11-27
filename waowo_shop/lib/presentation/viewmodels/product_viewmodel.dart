import 'package:flutter/material.dart';
import '../../data/models/index.dart';
import '../../data/repositories/product_repository.dart';

/// ViewModel pour les produits
class ProductViewModel extends ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  double _minPrice = 0;
  double _maxPrice = 10000;

  List<Product> get allProducts => _allProducts;
  List<Product> get filteredProducts => _filteredProducts;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;

  /// Charger les produits au démarrage
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allProducts = await _productRepository.getAllProducts();
      _categories = await _productRepository.getCategories();
      _categories.insert(0, 'All');
      _filteredProducts = _allProducts;
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filtrer par catégorie
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  /// Rechercher des produits
  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Filtrer par prix
  void filterByPrice(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  /// Appliquer tous les filtres
  void _applyFilters() {
    _filteredProducts = _allProducts;

    // Filtrer par catégorie
    if (_selectedCategory != 'All') {
      _filteredProducts = _filteredProducts
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    // Filtrer par recherche
    if (_searchQuery.isNotEmpty) {
      _filteredProducts = _filteredProducts
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Filtrer par prix
    _filteredProducts = _filteredProducts
        .where((p) => p.price >= _minPrice && p.price <= _maxPrice)
        .toList();

    notifyListeners();
  }

  /// Obtenir les produits recommandés
  Future<List<Product>> getRecommendedProducts() async {
    return _productRepository.getRecommendedProducts();
  }

  /// Obtenir un produit par ID
  Future<Product?> getProductById(String id) async {
    return _productRepository.getProductById(id);
  }

  /// Réinitialiser les filtres
  void resetFilters() {
    _selectedCategory = 'All';
    _searchQuery = '';
    _minPrice = 0;
    _maxPrice = 10000;
    _applyFilters();
  }
}
