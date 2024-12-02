import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService orderService = OrderService();
  List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  // Menambahkan pesanan
  Future<void> addOrder(OrderModel order) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await orderService.addOrder(user: user, order: order);
      _orders.add(order);
      print(
          "Order added: ${order.orderId}"); // Debug: pastikan order ditambahkan
      notifyListeners();
    }
  }

  // Mendapatkan pesanan pengguna
  Future<void> fetchOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      orderService.getOrdersByUserId(user.uid).listen((orders) {
        _orders = orders;
        print("Orders fetched: ${_orders.length}"); // Debug: cek jumlah orders
        notifyListeners();
      });
    }
  }
}
