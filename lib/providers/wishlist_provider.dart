import 'package:flutter/material.dart';
import 'package:shamo_app/models/product_model.dart';

import '../services/wishlist_service.dart';

class WishlistProvider with ChangeNotifier {
  List<ProductModel> _wishlist = [];
  final String _userId = '';

  List<ProductModel> get wishlist => _wishlist;

  set wishlist(List<ProductModel> wishlist) {
    _wishlist = wishlist;
    notifyListeners();
  }

  setProduct(ProductModel product) {
    if (!isWishlist(product)) {
      _wishlist.add(product);
      WishlistService().addToWishlist(_userId, product);
    } else {
      _wishlist.removeWhere((element) => element.id == product.id);
      WishlistService().removeFromWishlist(_userId, product.id.toString());
    }
    notifyListeners();
  }

  isWishlist(ProductModel product) {
    if (_wishlist.indexWhere((element) => element.id == product.id) == -1) {
      return false;
    } else {
      return true;
    }
  }
}
