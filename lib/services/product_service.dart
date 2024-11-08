import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductService {
  String baseUrl = 'http://192.168.1.10:8000/api';

  // lib/services/product_service.dart
  Future<List<ProductModel>> getProducts() async {
    try {
      var url = Uri.parse('$baseUrl/products');
      var headers = {'Content-Type': 'application/json'};

      var response = await http.get(url, headers: headers);
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Decoded JSON: $data'); // Untuk debugging

        List<ProductModel> products = [];
        List<dynamic> productList = data['data']['data'];

        for (var item in productList) {
          try {
            ProductModel product = ProductModel.fromJson(item);
            if (product.galleries != null && product.galleries!.isNotEmpty) {
              print('Gallery URL: ${product.galleries![0]}');
            }
            products.add(product);
          } catch (e) {
            print('Error parsing product: $e');
          }
        }

        return products;
      } else {
        throw Exception('Gagal mendapatkan produk');
      }
    } catch (e) {
      print('Error in getProducts: $e');
      rethrow;
    }
  }
}
