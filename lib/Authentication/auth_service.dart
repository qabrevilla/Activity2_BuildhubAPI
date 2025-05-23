import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginApi {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 3) {
      return 'Password must be at least 3 characters';
    }
    return null;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('https://api.buildhubware.com/api/v1/accounts/login');
    final headers = <String, String>{'Content-Type': 'application/json'};
    final body = jsonEncode(<String, String>{
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData.containsKey('token')) {
          print("Login successful! Token: ${responseData['token']}");
          AuthManager().setToken(responseData['token']); // store global token
          return {'success': true, 'token': responseData['token']};
        } else {
          return {'success': false, 'message': 'Invalid response from server'};
        }
      } else {
        switch (response.statusCode) {
          case 422:
            return {
              'success': false,
              'message': responseData['message'] ?? 'Invalid request!',
            };
          case 400:
            return {
              'success': false,
              'message':
                  responseData['message'] ?? 'Invalid email or password.',
            };
          default:
            return {
              'success': false,
              'message':
                  responseData['message'] ?? 'An unexpected error occurred.',
            };
        }
      }
    } catch (e) {
      print("Login error: $e");
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}

// Token Manager
class AuthManager {
  static final AuthManager _instance = AuthManager._internal();

  String? _token;

  factory AuthManager() {
    return _instance;
  }

  AuthManager._internal();

  String? get token => _token;

  void setToken(String token) {
    _token = token;
  }
}
