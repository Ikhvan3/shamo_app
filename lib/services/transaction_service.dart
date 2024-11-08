import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_model.dart';

class TransactionService {
  String baseUrl = 'http://192.168.1.10:8000/api';

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> checkout(List<CartModel> carts, double totalPrice) async {
    var url = Uri.parse('$baseUrl/checkout');
    String? token = await _getToken();

    if (token == null) {
      print('Token tidak ditemukan. Silakan login terlebih dahulu.');
      return false;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
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
    });

    print('Request Body: $body');

    try {
      var response = await http
          .post(
            url,
            headers: headers,
            body: body,
          )
          .timeout(Duration(seconds: 30));

      print('Status response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Server responded with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during checkout: $e');
      return false;
    }
  }
}
