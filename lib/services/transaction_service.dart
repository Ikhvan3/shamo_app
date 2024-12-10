import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cart_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart'; // Tambahkan import user model

class TransactionService {
  String baseUrl = 'http://192.168.1.26:8000/api';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>?> checkout(
      List<CartModel> carts, double totalPrice, UserModel currentUser) async {
    var url = Uri.parse('$baseUrl/checkout');
    String? token = await _getToken();

    if (token == null) {
      print('Token tidak ditemukan. Silakan login terlebih dahulu.');
      return null;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var body = jsonEncode({
      'address': 'Marsemoon',
      'items': carts
          .map((cart) => {
                'id': cart.product?.id,
                'quantity': cart.quantity,
              })
          .toList(),
      'status': "PENDING",
      'total_price': totalPrice,
      'shipping_price': 0,
      'payment_method': "credit_card",
    });

    try {
      print('Sending request to $url');
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['data'] == null || data['data']['transaction'] == null) {
          throw Exception('Unexpected API response structure');
        }

        // Simpan ke Firestore dengan informasi user
        var transactionData = TransactionModel(
          id: data['data']['transaction']['id']?.toString(),
          status: data['data']['transaction']['status'],
          totalPrice: totalPrice,
          shippingPrice: 0,
          paymentMethod: "credit_card",
          address: "Marsemoon",
          items: carts,
          createdAt: DateTime.now(),

          // Tambahkan informasi user
          userId: currentUser.id,
          userName: currentUser.name,
          userEmail: currentUser.email,
        );

        await _firestore
            .collection('transactions')
            .doc(transactionData.id)
            .set(transactionData.toJson());

        return {
          'snap_token': data['data']['snap_token'],
          'transaction_id': transactionData.id,
        };
      } else {
        print('API Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during checkout: $e');
      return null;
    }
  }

  Future<List<TransactionModel>> fetchTransactionsFromFirestore(
      UserModel currentUser) async {
    try {
      // Ambil transaksi berdasarkan user ID
      QuerySnapshot snapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: currentUser.id)
          .get();

      return snapshot.docs.map((doc) {
        return TransactionModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching transactions from Firestore: $e');
    }
  }
}
