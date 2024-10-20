import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart_model.dart';

class TransactionService {
  String baseUrl = 'http://shamo-bwa-apk.test/api';

  Future<bool> checkout(
      String token, List<CartModel> carts, double totalPrice) async {
    var url = Uri.parse('$baseUrl/checkout');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    print('Token: $token');

    var body = jsonEncode(
      {
        'address': 'Marsemoon',
        'items': carts
            .map(
              (cart) => {
                'id': cart.product!.id,
                'quantity': cart.quantity,
              },
            )
            .toList(),
        'status': "PENDING",
        'total_price': totalPrice,
        'shipping_price': 0,
      },
    );

    try {
      var response = await http
          .post(
            url,
            headers: headers,
            body: body,
          )
          .timeout(Duration(seconds: 10)); // Tambahkan batas waktu

      print('Status respons: ${response.statusCode}');
      print('Isi respons: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Server merespons dengan kode status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Kesalahan selama checkout: $e');
      return false;
    }
  }
}
