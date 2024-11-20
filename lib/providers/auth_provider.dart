import 'package:flutter/material.dart';
import 'package:shamo_app/services/auth_service.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_provider.dart';

class AuthProvider with ChangeNotifier {
  late UserModel _user;
  String? _token;
  final CartProvider cartProvider;

  AuthProvider({required this.cartProvider});

  UserModel get user => _user;
  String? get token => _token;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    if (token.isEmpty) {
      print('Token is empty, skipping save.');
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _token = token;
    notifyListeners();
  }

  Future<String?> getToken() async {
    if (_token != null) return _token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    return _token;
  }

  Future<bool> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserModel user = await AuthService().register(
        name: name,
        username: username,
        email: email,
        password: password,
      );

      _user = user;

      String? token = await AuthService().getToken();
      if (token != null) {
        await _saveToken(token);
      }

      // Initialize cart for new user
      await cartProvider.initializeCart(user);

      return true;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      UserModel user = await AuthService().login(
        email: email,
        password: password,
      );

      _user = user;

      String? token = await AuthService().getToken();
      if (token != null) {
        await _saveToken(token);
      }

      // Initialize cart for logged in user
      await cartProvider.initializeCart(user);

      return true;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      // Clear cart data
      await cartProvider.clearCart();

      // Clear local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      _token = null;

      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
