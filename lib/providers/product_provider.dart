import 'package:flutter/material.dart';
import 'package:shamo_app/models/product_model.dart';
import 'package:shamo_app/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  String _selectedCategory = 'Semua Sayuran';

  List<ProductModel> get products =>
      _filteredProducts.isEmpty ? _products : _filteredProducts;
  String get selectedCategory => _selectedCategory;

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    if (category == 'Semua Sayuran') {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((product) => product.category?.name == category)
          .toList();
    }
    notifyListeners();
  }

  Future<void> getProducts() async {
    try {
      List<ProductModel> products = await ProductService().getProducts();
      _products = products;
      // Inisialisasi filtered products dengan semua produk
      _filteredProducts = products;
      notifyListeners();
    } catch (e) {
      print('Error mengambil produk: $e');
    }
  }
}
