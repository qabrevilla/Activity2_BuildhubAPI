import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('https://api.buildhubware.com/api/v1/accounts/login');
    final headers = <String, String>{'Content-Type': 'application/json'};
    final body = jsonEncode(<String, String>{
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData.containsKey('token')) {
          return {'success': true, 'token': responseData['token']};
        } else {
          return {'success': false, 'message': 'Invalid response from server'};
        }
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Invalid credentials',
        };
      }
    } catch (e) {
      debugPrint("Login error: $e");
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
