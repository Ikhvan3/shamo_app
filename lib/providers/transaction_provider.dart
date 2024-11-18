import 'package:flutter/material.dart';
import 'package:shamo_app/services/transaction_service.dart';
import '../models/cart_model.dart';

class TransactionProvider with ChangeNotifier {
  Future<Map<String, dynamic>?> checkout(
      List<CartModel> carts, double totalPrice) async {
    try {
      if (carts.isEmpty) {
        print('Keranjang kosong');
        return null;
      }

      // Metode ini harus mengembalikan String? karena snapToken adalah String?
      Map<String, dynamic>? snapToken =
          await TransactionService().checkout(carts, totalPrice);

      if (snapToken != null) {
        notifyListeners();
      }

      return snapToken;
    } catch (e) {
      print('Kesalahan di TransactionProvider: $e');
      return null;
    }
  }
}
