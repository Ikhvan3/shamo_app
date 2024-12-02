import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';
import '../models/transaction_model.dart';

class TransactionService {
  String baseUrl = 'http://192.168.1.25:8000/api';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>?> checkout(
      List<CartModel> carts, double totalPrice) async {
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

        // Simpan ke Firestore
        var transactionData = TransactionModel(
          id: data['data']['transaction']['id'],
          status: data['data']['transaction']['status'],
          totalPrice: totalPrice,
          shippingPrice: 0,
          paymentMethod: "credit_card",
          address: "Marsemoon",
          items: carts,
          createdAt: DateTime.now(),
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

  Future<List<TransactionModel>> fetchTransactionsFromFirestore() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('transactions').get();

      return snapshot.docs.map((doc) {
        return TransactionModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching transactions from Firestore: $e');
    }
  }
}
