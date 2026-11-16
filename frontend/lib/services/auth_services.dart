import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080';
  
  static final FlutterSecureStorage storage =
    const FlutterSecureStorage();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      await storage.write(
        key: 'jwt_token',
        value: data['token'],
      );

      return data;
    }

    if (response.statusCode == 401) {
      throw Exception('Invalid email or password');
    }

    if (response.statusCode == 403) {
      throw Exception('Your account is disabled');
    }

    throw Exception(
      'Login failed. Status: ${response.statusCode}',
    );
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }
}
