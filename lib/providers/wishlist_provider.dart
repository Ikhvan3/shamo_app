import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../models/user_model.dart';
import '../services/wishlist_service.dart';
import 'auth_provider.dart';

class WishlistProvider with ChangeNotifier {
  List<ProductModel> _wishlist = [];
  final WishlistService _wishlistService;
  final AuthProvider _authProvider;
  UserModel? _user;

  WishlistProvider({
    required WishlistService wishlistService,
    required AuthProvider authProvider,
  })  : _wishlistService = wishlistService,
        _authProvider = authProvider {
    // Automatically set user from auth provider
    _user = _authProvider.user;
  }

  List<ProductModel> get wishlist => _wishlist;

  void setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  // Stream to load wishlist
  Stream<List<ProductModel>> get loadWishlist {
    if (_user == null) {
      throw Exception('User not set');
    }

    return _wishlistService.getWishlistByUserId(_user!.id).map((products) {
      _wishlist = products;
      notifyListeners();
      return products;
    });
  }

  // Toggle product in wishlist
  Future<void> toggleWishlist(ProductModel product) async {
    if (_user == null) {
      throw Exception('User not set');
    }

    bool isCurrentlyInWishlist =
        await _wishlistService.isInWishlist(user: _user, product: product);

    if (!isCurrentlyInWishlist) {
      await _wishlistService.addToWishlist(user: _user, product: product);
      _wishlist.add(product);
    } else {
      await _wishlistService.removeFromWishlist(user: _user, product: product);
      _wishlist.removeWhere((p) => p.id == product.id);
    }

    notifyListeners();
  }

  // Check if product is in wishlist
  Future<bool> isWishlist(ProductModel product) async {
    if (_user == null) {
      throw Exception('User not set');
    }

    return await _wishlistService.isInWishlist(user: _user, product: product);
  }
}
