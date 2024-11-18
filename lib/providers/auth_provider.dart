import 'package:flutter/material.dart';
import 'package:shamo_app/services/auth_service.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_provider.dart';

class AuthProvider with ChangeNotifier {
  late UserModel _user;
  String? _token;

  UserModel get user => _user;
  String? get token => _token;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // Fungsi untuk menyimpan token
  Future<void> _saveToken(String token) async {
    if (token == null || token.isEmpty) {
      print('Token is null or empty, skipping save.');
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _token = token;
    notifyListeners();
  }

  // Fungsi untuk mengambil token
  Future<String?> getToken() async {
    if (_token != null) return _token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    return _token;
  }

  // Fungsi untuk menyimpan permanent token
  Future _savePermanentToken(String permanentToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('permanent_token', permanentToken);
    notifyListeners();
  }

  // Fungsi untuk mengambil permanent token
  Future<String?> getPermanentToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('permanent_token');
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

      // Ambil dan simpan token
      String? token = await AuthService().getToken();
      if (token != null) {
        await _saveToken(token);
      }

      // Ambil dan simpan permanent token
      String? permanentToken = await AuthService().getPermanentToken();
      if (permanentToken != null) {
        await _savePermanentToken(permanentToken);
      }

      return true;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    required CartProvider cartProvider, // Tambahkan parameter ini
  }) async {
    try {
      UserModel user = await AuthService().login(
        email: email,
        password: password,
      );

      _user = user;

      // Ambil dan simpan token
      String? token = await AuthService().getToken();
      if (token != null) {
        await _saveToken(token);
      }

      // Ambil dan simpan permanent token
      String? permanentToken = await AuthService().getPermanentToken();
      if (permanentToken != null) {
        await _savePermanentToken(permanentToken);
        // Update cart provider dengan permanent token baru
        await cartProvider.updatePermanentToken(permanentToken);
      }

      return true;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
    notifyListeners();
  }
}
