import 'package:http/http.dart' as http;
import 'auth_services.dart';

class ApiClient {
  static const String baseUrl = 'http://localhost:8080';

  final AuthService _authService = AuthService();

  Future<Map<String, String>> _headers({
    bool jsonContent = true,
  }) async {
    final token = await _authService.getToken();
    return {
      if (jsonContent) 'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers(),
    );

    return response;
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: queryParameters,
    );

    final response = await http.put(
      uri,
      headers: await _headers(),
    );

    return response;
  }
}
