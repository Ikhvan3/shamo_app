import 'package:flutter/material.dart';
import 'package:shamo_app/services/auth_service.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      // Simpan token setelah register
      await _saveToken(
        await AuthService().getToken().toString(),
      );
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
      return true;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // // Fungsi untuk logout
  // Future<void> logout() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('token');
  //   _token = null;
  //   notifyListeners();
  // }
}
