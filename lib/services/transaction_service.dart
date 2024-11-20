import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';

class TransactionService {
  String baseUrl = 'http://192.168.1.22:8000/api';

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('Token yang ditemukan: $token'); // Debug token
    return token;
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
      print('Checkout URL: $url');
      print('Headers: $headers');
      print('Body: $body');

      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Pastikan Anda mengakses snap_token dengan benar
        return {
          'snap_token': data['data']['snap_token'],
          'transaction_id': data['data']['transaction']['id']
        };
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during checkout: $e');
      return null;
    }
  }
}
