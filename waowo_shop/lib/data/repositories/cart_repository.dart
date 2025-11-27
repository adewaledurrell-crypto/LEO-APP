import '../models/index.dart';
import '../database/database_helper.dart';

/// Repository pour le panier
class CartRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Obtenir les articles du panier
  Future<List<CartItem>> getCartItems() async {
    return _databaseHelper.getCartItems();
  }

  /// Ajouter au panier
  Future<bool> addToCart(CartItem item) async {
    return _databaseHelper.addToCart(item);
  }

  /// Supprimer du panier
  Future<bool> removeFromCart(String cartItemId) async {
    return _databaseHelper.removeFromCart(cartItemId);
  }

  /// Vider le panier
  Future<bool> clearCart() async {
    return _databaseHelper.clearCart();
  }
}
