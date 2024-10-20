import 'package:flutter/material.dart';
import 'package:shamo_app/services/transaction_service.dart';
import '../models/cart_model.dart';

class TransactionProvider with ChangeNotifier {
  Future<bool> checkout(List<CartModel> carts, double totalPrice) async {
    try {
      if (carts.isEmpty) {
        print('Keranjang kosong');
        return false;
      }

      bool result = await TransactionService().checkout(carts, totalPrice);
      if (result) {
        notifyListeners();
      }
      return result;
    } catch (e) {
      print('Kesalahan di TransactionProvider: $e');
      return false;
    }
  }
}
