import 'package:flutter/material.dart';
import 'package:shamo_app/services/transaction_service.dart';
import '../models/cart_model.dart';

class TransactionProvider with ChangeNotifier {
  Future<bool> checkout(
      String token, List<CartModel> carts, double totalPrice) async {
    try {
      return await TransactionService().checkout(token, carts, totalPrice);
    } catch (e) {
      print('Kesalahan di TransactionProvider: $e');
      return false;
    }
  }
}
