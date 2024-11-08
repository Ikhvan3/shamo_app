import 'dart:convert';
import 'package:http/http.dart' as http;

import '../helpers/image_url_helper.dart';
import '../models/product_model.dart';

class ProductService {
  Future<List<ProductModel>> getProducts() async {
    var url = Uri.parse('${AppConfig.apiUrl}/products');
    var headers = {'Content-Type': 'application/json'};

    try {
      var response = await http.get(url, headers: headers);
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data']['data'];
        List<ProductModel> products = [];

        for (var item in data) {
          try {
            var product = ProductModel.fromJson(item);
            if (product.galleries != null && product.galleries!.isNotEmpty) {
              print(
                  'Product ${product.name} image URL: ${product.galleries![0].url}');
            }
            products.add(product);
          } catch (e) {
            print('Error parsing product: $e');
          }
        }

        return products;
      } else {
        throw Exception('Gagal Get Products! Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getProducts: $e');
      throw Exception('Gagal melakukan request: $e');
    }
  }
}
