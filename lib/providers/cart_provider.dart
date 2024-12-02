import 'dart:async';

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
    try {
      cartService
          .getCartByUserId(userId: user.id.toString())
          .listen((cartList) {
        _carts = cartList;
        notifyListeners();
      });
    } catch (e) {
      print('Error initializing cart: $e');
    }
  }

  Future<void> addCart(ProductModel product) async {
    if (_user == null) return;
    try {
      // Cek apakah produk sudah ada dalam cart
      int existingIndex =
          _carts.indexWhere((cart) => cart.product!.id == product.id);

      if (existingIndex != -1) {
        // Jika produk sudah ada, update quantity
        _carts[existingIndex].quantity =
            (_carts[existingIndex].quantity ?? 0) + 1;
        await cartService.updateCartItem(
          cartId: _carts[existingIndex].id!,
          quantity: _carts[existingIndex].quantity!,
        );
      } else {
        // Jika produk belum ada, tambahkan produk baru ke cart
        CartModel newCart = CartModel(
          product: product,
          quantity: 1,
        );
        await cartService.addToCart(user: _user!, cart: newCart);
        // _carts.add(newCart);
      }
      // Mengupdate tampilan setelah penambahan cart
      notifyListeners();
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> removeCart(String cartId) async {
    try {
      await cartService.removeFromCart(cartId: cartId);
      _carts.removeWhere((cart) => cart.id == cartId);
      notifyListeners();
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  Future<void> addQuantity(String cartId) async {
    try {
      int index = _carts.indexWhere((cart) => cart.id == cartId);
      if (index != -1) {
        int newQuantity = (_carts[index].quantity ?? 0) + 1;
        _carts[index].quantity = newQuantity;

        await cartService.updateCartItem(
          cartId: cartId,
          quantity: newQuantity,
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> reduceQuantity(String cartId) async {
    try {
      int index = _carts.indexWhere((cart) => cart.id == cartId);
      if (index != -1) {
        int newQuantity = (_carts[index].quantity ?? 0) - 1;
        if (newQuantity <= 0) {
          await removeCart(cartId);
        } else {
          _carts[index].quantity = newQuantity;
          await cartService.updateCartItem(
            cartId: cartId,
            quantity: newQuantity,
          );
          notifyListeners();
        }
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
    return _carts.indexWhere((cart) => cart.product!.id == product.id) != -1;
  }
}
