import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static Future<bool> login(
    String email,
    String password,
    bool rememberMe,
    BuildContext context,
  ) async {
    final url = Uri.parse('https://api.buildhubware.com/api/v1/accounts/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'rememberMe': rememberMe,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login Successful')));
      return true;
    } else {
      String errorMessage = 'Login Failed';

      try {
        final data = jsonDecode(response.body);
        if (data['message'] != null) {
          errorMessage = data['message'];
        }
      } catch (e) {
        // nothing
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      return false;
    }
  }
}
