import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductService {
  String baseUrl = 'http://shamo-bwa-apk.test/api';

  Future<List<ProductModel>> getProducts() async {
    var url = Uri.parse('$baseUrl/products');
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(url, headers: headers);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('JSON Response: $jsonResponse'); // Lihat semua data respons

      List data = jsonResponse['data']['data'];
      print('Product Data: $data'); // Lihat data produk

      List<ProductModel> products = [];

      for (var item in data) {
        try {
          products.add(ProductModel.fromJson(item));
        } catch (e) {
          print(
              'Error parsing product: $e'); // Tampilkan error spesifik untuk item tertentu
        }
      }

      return products;
    } else {
      throw Exception(
          'Failed to get products. Status code: ${response.statusCode}');
    }
  }
}
