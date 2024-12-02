import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  final TransactionService _transactionService = TransactionService();

  Future<void> fetchTransactions(
      {required UserModel currentUser, bool forceRefresh = false}) async {
    try {
      if (_transactions.isEmpty || forceRefresh) {
        _transactions = await _transactionService
            .fetchTransactionsFromFirestore(currentUser);
        notifyListeners();
      }
    } catch (e) {
      print('Kesalahan saat mengambil transaksi dari Firestore: $e');
    }
  }

  Future<Map<String, dynamic>?> checkout(
      List<CartModel> carts, double totalPrice, UserModel currentUser) async {
    try {
      Map<String, dynamic>? snapToken =
          await _transactionService.checkout(carts, totalPrice, currentUser);

      if (snapToken != null) {
        // Fetch transaksi terbaru dari Firestore setelah checkout berhasil
        await fetchTransactions(currentUser: currentUser, forceRefresh: true);
        notifyListeners();
      }

      return snapToken;
    } catch (e) {
      print('Kesalahan di TransactionProvider: $e');
      return null;
    }
  }
}
