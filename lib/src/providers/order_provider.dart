import 'package:cengodelivery/src/interfaces/order.dart';
import 'package:flutter/foundation.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void removeOrder(Order order) {
    _orders.remove(order);
    notifyListeners();
  }

  void updateOrder(Order updatedOrder) {
    final index = _orders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      _orders[index] = updatedOrder;
      notifyListeners();
    }
  }

  void setOrders(List<Order> orders) {
    _orders = orders;
    notifyListeners();
  }

  bool allOrdersHaveImages() {
    if (_orders.isEmpty) {
      return false; // Si no hay órdenes, retornamos false
    }

    return _orders.every((order) {
      return order.pickupImages != null && order.pickupImages!.isNotEmpty;
    });
  }

  // Método opcional para obtener órdenes sin imágenes
  List<Order> getOrdersWithoutImages() {
    return _orders.where((order) {
      return order.pickupImages == null || order.pickupImages!.isEmpty;
    }).toList();
  }
}
