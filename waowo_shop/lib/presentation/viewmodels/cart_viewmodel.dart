import 'package:flutter/material.dart';
import '../../data/models/index.dart';
import '../../data/repositories/cart_repository.dart';
import 'package:uuid/uuid.dart';

/// ViewModel pour le panier
class CartViewModel extends ChangeNotifier {
  final CartRepository _cartRepository = CartRepository();

  List<CartItem> _cartItems = [];
  bool _isLoading = false;

  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;

  /// Calculer le total du panier
  double get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + item.subtotal);
  }

  /// Nombre d'articles
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  /// Charger le panier
  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cartItems = await _cartRepository.getCartItems();
    } catch (e) {
      print('Error loading cart: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ajouter au panier
  Future<void> addToCart({
    required String productId,
    required String productName,
    required double price,
    required String imageUrl,
    int quantity = 1,
  }) async {
    try {
      // Vérifier si le produit est déjà dans le panier
      final existingItem = _cartItems.firstWhere(
        (item) => item.productId == productId,
        orElse: () => CartItem(
          id: '',
          productId: '',
          productName: '',
          price: 0,
          imageUrl: '',
          quantity: 0,
        ),
      );

      if (existingItem.id.isNotEmpty) {
        // Augmenter la quantité
        existingItem.quantity += quantity;
        await _cartRepository.addToCart(existingItem);
      } else {
        // Ajouter un nouvel article
        final newItem = CartItem(
          id: const Uuid().v4(),
          productId: productId,
          productName: productName,
          price: price,
          imageUrl: imageUrl,
          quantity: quantity,
        );
        _cartItems.add(newItem);
        await _cartRepository.addToCart(newItem);
      }

      notifyListeners();
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  /// Supprimer du panier
  Future<void> removeFromCart(String cartItemId) async {
    try {
      _cartItems.removeWhere((item) => item.id == cartItemId);
      await _cartRepository.removeFromCart(cartItemId);
      notifyListeners();
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  /// Mettre à jour la quantité
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    try {
      final item = _cartItems.firstWhere((item) => item.id == cartItemId);
      item.quantity = quantity;
      await _cartRepository.addToCart(item);
      notifyListeners();
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  /// Vider le panier
  Future<void> clearCart() async {
    try {
      _cartItems.clear();
      await _cartRepository.clearCart();
      notifyListeners();
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }
}
