import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductService {
  String baseUrl = 'http://shamo-bwa-apk.test/api';

  Future<List<ProductModel>> getProducts() async {
    var url = Uri.parse(
        '$baseUrl/products?id=1&limit=6&name=Nike&description=&price_from=1&price_to=100000&tags=popular&categories=1');
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(url, headers: headers);

    print(response.body);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data']['data'];
      List<ProductModel> products = [];

      for (var item in data) {
        products.add(ProductModel.fromJson(item));
      }

      return products;
    } else {
      throw Exception('Gagal Get Products');
    }
  }
}
