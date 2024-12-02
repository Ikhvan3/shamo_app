import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shamo_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String baseUrl = 'http://192.168.1.25:8000/api';

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<UserModel> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    var url = Uri.parse('$baseUrl/register');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    });

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        UserModel user = UserModel.fromJson(data['user']);
        String token = 'Bearer ' + data['access_token'];

        await _saveToken(token);

        return user;
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      print('Error during registration: $e');
      throw Exception('Registration failed: $e');
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    var url = Uri.parse('$baseUrl/login');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      debugPrint('Attempting to login with URL: $url');
      debugPrint('Request body: $body');

      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        UserModel user = UserModel.fromJson(data['user']);
        String token = 'Bearer ' + data['access_token'];

        debugPrint('Login successful. Saving token.');
        await _saveToken(token);

        return user;
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (error) {
      debugPrint('Error during login: $error');
      throw Exception('Login failed: $error');
    }
  }
}
