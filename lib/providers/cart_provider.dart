import 'package:flutter/material.dart';
import 'package:shamo_app/models/product_model.dart';
import 'package:shamo_app/models/cart_model.dart';
import 'package:shamo_app/models/user_model.dart';
import 'package:shamo_app/services/cart_service.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];
  late CartService cartService;
  UserModel? _user;

  List<CartModel> get carts => _carts;

  CartProvider() {
    cartService = CartService();
  }

  Future<void> initializeCart(UserModel user) async {
    _user = user;
    _carts = (await cartService.getCartByUserId(userId: user.id.toString()))
        as List<CartModel>;
    notifyListeners();
  }

  Future<void> addCart(ProductModel product) async {
    if (_user == null) return;
    try {
      if (productExist(product)) {
        int index =
            _carts.indexWhere((element) => element.product!.id == product.id);
        _carts[index].quantity = (_carts[index].quantity ?? 0) + 1;
        await cartService.updateCartItem(
          cartId: _carts[index].id.toString(),
          quantity: _carts[index].quantity!,
        );
      } else {
        CartModel newCart = CartModel(
          product: product,
          quantity: 1,
        );
        await cartService.addToCart(user: _user!, cart: newCart);
        _carts.add(newCart);
      }
      notifyListeners();
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> removeCart(int id) async {
    try {
      await cartService.removeFromCart(cartId: id.toString());
      // Mengambil ulang data cart setelah item dihapus
      _carts =
          await cartService.getCartByUserId(userId: _user!.id.toString()).first;
      notifyListeners(); // Update UI
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  Future<void> addQuantity(int id) async {
    try {
      await cartService.updateCartItem(
        cartId: id.toString(),
        quantity: (_carts[id].quantity ?? 0) + 1,
      );
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> reduceQuantity(int id) async {
    try {
      int newQuantity = (_carts[id].quantity ?? 0) - 1;
      if (newQuantity <= 0) {
        await removeCart(id);
      } else {
        await cartService.updateCartItem(
          cartId: id.toString(),
          quantity: newQuantity,
        );
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  int totalItems() {
    int total = 0;
    for (var item in _carts) {
      total += item.quantity!;
    }
    return total;
  }

  double totalPrice() {
    double total = 0;
    for (var item in _carts) {
      total += (item.quantity! * item.product!.price!);
    }
    return total;
  }

  bool productExist(ProductModel product) {
    return _carts.indexWhere((element) => element.product!.id == product.id) !=
        -1;
  }

  Future<void> clearCart() async {
    if (_user == null) return;
    try {
      await cartService.clearCart(userId: _user!.id.toString());
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }
}
