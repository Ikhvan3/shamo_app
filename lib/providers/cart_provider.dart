import 'package:flutter/material.dart';
import 'package:shamo_app/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];
  String _permanentToken = ''; // Menggunakan permanent token sebagai identifier
  List<CartModel> get carts => _carts;

  // Constructor
  CartProvider() {
    _loadCart();
  }

  // Load cart berdasarkan permanent token
  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    _permanentToken = prefs.getString('permanent_token') ?? '';

    if (_permanentToken.isNotEmpty) {
      // Load cart data dari SharedPreferences berdasarkan permanent token
      final String cartKey = 'cart_$_permanentToken';
      final String? cartData = prefs.getString(cartKey);

      if (cartData != null) {
        // Convert string data menjadi List<CartModel>
        // Implementasikan konversi sesuai format penyimpanan Anda
        _carts = _deserializeCart(cartData);
        notifyListeners();
      }
    }
  }

  // Simpan cart ke SharedPreferences
  Future<void> _saveCart() async {
    if (_permanentToken.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final String cartKey = 'cart_$_permanentToken';

      // Convert cart data menjadi string untuk disimpan
      final String cartData = _serializeCart(_carts);
      await prefs.setString(cartKey, cartData);
    }
  }

  // Helper method untuk mengubah cart menjadi string
  String _serializeCart(List<CartModel> carts) {
    // Implementasikan serialisasi sesuai kebutuhan
    // Contoh sederhana (Anda perlu menyesuaikan dengan model Anda):
    return carts
        .map((cart) => {
              'id': cart.id,
              'product_id': cart.product?.id,
              'quantity': cart.quantity,
              // tambahkan field lain yang diperlukan
            })
        .toString();
  }

  // Helper method untuk mengubah string menjadi List<CartModel>
  List<CartModel> _deserializeCart(String cartData) {
    // Implementasikan deserialisasi sesuai kebutuhan
    // Ini hanya contoh, sesuaikan dengan format penyimpanan Anda
    return []; // Implementasikan konversi yang sesuai
  }

  set carts(List<CartModel> carts) {
    _carts = carts;
    _saveCart(); // Simpan setiap kali cart diupdate
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
    _saveCart(); // Simpan perubahan
    notifyListeners();
  }

  removeCart(int id) {
    _carts.removeAt(id);
    _saveCart(); // Simpan perubahan
    notifyListeners();
  }

  addQuantity(int id) {
    _carts[id].quantity = (_carts[id].quantity ?? 0) + 1;
    _saveCart(); // Simpan perubahan
    notifyListeners();
  }

  reduceQuantity(int id) {
    _carts[id].quantity = (_carts[id].quantity ?? 0) - 1;
    if (_carts[id].quantity == 0) {
      _carts.removeAt(id);
    }
    _saveCart(); // Simpan perubahan
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

  // Fungsi untuk logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Tidak perlu menghapus cart data karena kita ingin mempertahankannya
    // Cukup clear data di memory
    _carts.clear();
    notifyListeners();
  }

  // Fungsi untuk mengupdate permanent token (dipanggil setelah login)
  Future<void> updatePermanentToken(String newToken) async {
    _permanentToken = newToken;
    await _loadCart(); // Reload cart data dengan token baru
  }
}
