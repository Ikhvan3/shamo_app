import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  String _userToken = ''; // Token untuk pengguna yang sedang login

  List<OrderModel> get orders => _orders;

  // Constructor
  OrderProvider() {
    _loadOrders();
  }

  // Ambil token dari SharedPreferences (atau metode lain yang sesuai)
  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('user_token') ??
        ''; // Ambil token dari penyimpanan lokal
    _fetchOrdersFromServer(); // Ambil order berdasarkan token dari server atau database
  }

  // Method to add order after successful payment
  void addOrder(OrderModel order) {
    _orders.add(order);
    notifyListeners();
  }

  // Method to fetch orders (this could be from an API or local storage)
  // Fungsi untuk mengambil order berdasarkan token pengguna
  Future<void> _fetchOrdersFromServer() async {
    if (_userToken.isNotEmpty) {
      // Panggil API untuk mengambil data order berdasarkan token pengguna
      // Misalnya, menggunakan `http` atau API lain sesuai kebutuhan
      // Contoh:
      // final response = await api.fetchOrders(_userToken);
      // if (response.statusCode == 200) {
      //   _orders = response.orders;
      // }
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token'); // Hapus token pengguna
    _userToken = ''; // Reset token
    _orders.clear(); // Hapus data order di local memory
    notifyListeners();
  }
}
