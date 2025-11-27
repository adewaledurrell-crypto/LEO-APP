import '../models/index.dart';
import '../database/database_helper.dart';

/// Repository pour les commandes
class OrderRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Créer une nouvelle commande
  Future<bool> createOrder(Order order) async {
    return _databaseHelper.createOrder(order);
  }

  /// Obtenir les commandes par utilisateur
  Future<List<Order>> getOrdersByUserId(String userId) async {
    return _databaseHelper.getOrdersByUserId(userId);
  }

  /// Mettre à jour le statut de la commande
  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    return _databaseHelper.updateOrderStatus(orderId, status);
  }
}
