import 'package:flutter/material.dart';
import '../../data/models/index.dart';
import '../../data/repositories/order_repository.dart';
import 'package:uuid/uuid.dart';

/// ViewModel pour les commandes
class OrderViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();

  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  /// Charger les commandes de l'utilisateur
  Future<void> loadOrders(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _orderRepository.getOrdersByUserId(userId);
      _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Error loading orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Créer une nouvelle commande
  Future<bool> createOrder({
    required String userId,
    required List<CartItem> items,
    required double totalPrice,
  }) async {
    try {
      final order = Order(
        id: const Uuid().v4(),
        userId: userId,
        items: items,
        totalPrice: totalPrice,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      final success = await _orderRepository.createOrder(order);
      if (success) {
        _orders.insert(0, order);
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('Error creating order: $e');
      return false;
    }
  }

  /// Mettre à jour le statut de la commande
  Future<bool> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      final success = await _orderRepository.updateOrderStatus(orderId, status);
      if (success) {
        final orderIndex = _orders.indexWhere((o) => o.id == orderId);
        if (orderIndex != -1) {
          final order = _orders[orderIndex];
          _orders[orderIndex] = Order(
            id: order.id,
            userId: order.userId,
            items: order.items,
            totalPrice: order.totalPrice,
            status: status,
            createdAt: order.createdAt,
            updatedAt: DateTime.now(),
          );
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }

  /// Obtenir le nombre total de commandes
  int get totalOrders => _orders.length;

  /// Obtenir le nombre de commandes en attente
  int get pendingOrders =>
      _orders.where((o) => o.status == OrderStatus.pending).length;

  /// Obtenir le nombre de commandes livrées
  int get deliveredOrders =>
      _orders.where((o) => o.status == OrderStatus.delivered).length;
}
