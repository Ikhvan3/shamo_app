import 'package:flutter/material.dart';
import 'package:shamo_app/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];
  String _userToken = ''; // Menyimpan token pengguna yang sedang login
  List<CartModel> get carts => _carts;

  // Constructor
  CartProvider() {
    _loadCart();
  }

  // Ambil token dari SharedPreferences dan muat data cart
  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('user_token') ??
        ''; // Ambil token dari penyimpanan lokal
    _fetchCartFromServer(); // Ambil data cart berdasarkan token
  }

  // Ambil data cart dari server atau database sesuai dengan token pengguna
  Future<void> _fetchCartFromServer() async {
    if (_userToken.isNotEmpty) {
      // Panggil API untuk mengambil data cart berdasarkan token pengguna
      // Misalnya, menggunakan `http` atau API lain sesuai kebutuhan
      // Contoh:
      // final response = await api.fetchCart(_userToken);
      // if (response.statusCode == 200) {
      //   _carts = response.cartItems;
      // }
    }
  }

  set carts(List<CartModel> carts) {
    _carts = carts;
    notifyListeners();
  }

  addCart(ProductModel product) {
    if (productExist(product)) {
      int index =
          _carts.indexWhere((element) => element.product!.id == product.id);
      _carts[index].quantity = (_carts[index].quantity ?? 0) + 1;
    } else {
      _carts.add(
        CartModel(
          id: _carts.length,
          product: product,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  removeCart(int id) {
    _carts.removeAt(id);
    notifyListeners();
  }

  addQuantity(int id) {
    _carts[id].quantity = (_carts[id].quantity ?? 0) + 1;
    notifyListeners();
  }

  reduceQuantity(int id) {
    _carts[id].quantity = (_carts[id].quantity ?? 0) - 1;
    if (_carts[id].quantity == 0) {
      _carts.removeAt(id);
    }
    notifyListeners();
  }

  totalItems() {
    int total = 0;
    for (var item in _carts) {
      total += item.quantity!;
    }
    return total;
  }

  totalPrice() {
    double total = 0;
    for (var item in _carts) {
      total += (item.quantity! * item.product!.price!);
    }
    return total;
  }

  productExist(ProductModel product) {
    if (_carts.indexWhere((element) => element.product!.id == product.id) ==
        -1) {
      return false;
    } else {
      return true;
    }
  }

  // Fungsi untuk logout dan menghapus data cart
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token'); // Hapus token pengguna
    _userToken = ''; // Reset token
    _carts.clear(); // Hapus data cart
    notifyListeners();
  }
}
