import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:9188/api/auth";
  //static const String baseUrl = "http://10.0.2.2:9188/api/auth";
  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Login failed: ${response.statusCode}");
    }
  }

  static Future<String> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"username": username, "email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Registration failed: ${response.statusCode}");
    }
  }
}