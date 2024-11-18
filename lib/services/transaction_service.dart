import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:shamo_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_model.dart';

class TransactionService {
  String baseUrl = 'http://192.168.1.11:8000/api';

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
        var data = jsonDecode(response.body);
        String snapToken = data['snap_token'];

        // Initialize Midtrans SDK
        await _startMidtransTransaction(snapToken);
        return true;
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during checkout: $e');
      return false;
    }
  }

  Future<void> _startMidtransTransaction(String snapToken) async {
    try {
      final midtrans = await MidtransSDK.init(
        config: MidtransConfig(
          clientKey: 'Mid-client-6RNbPG6IEDvZvHBi',
          merchantBaseUrl: baseUrl,
          colorTheme: ColorTheme(
            colorPrimary: backgroundColor8,
            colorPrimaryDark: backgroundColor1,
            colorSecondary: backgroundColor3,
          ),
        ),
      );

      // Start the payment UI flow without expecting a direct result return
      await midtrans.startPaymentUiFlow(
        token: snapToken,
      );

      // Handle the result using some callback or listener method if needed (this will depend on the SDK)
      // You can listen to the result here after the payment UI flow ends.
      print('Payment UI flow completed.');
    } catch (e) {
      print('Error initializing Midtrans SDK: $e');
    }
  }
}
