import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'token_provider.dart';

class AuthService {
  final String baseUrl;
  final TokenProvider tokenProvider;

  AuthService({required this.baseUrl, required this.tokenProvider});

  /// Devuelve el token actual del provider
  String? get token => tokenProvider.token;

  /// Cargar token persistido al iniciar la app
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('auth_token');

    if (savedToken != null) {
      tokenProvider.setToken(savedToken);
    }
  }

  /// Login: guarda token en SharedPreferences y en TokenProvider
  Future<bool> login(String name, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      tokenProvider.setToken(token);

      return true;
    }

    return false;
  }

  /// Login que retorna la respuesta completa (token + datos de usuario)
  Future<Map<String, dynamic>?> loginAndGetUser(
      String name, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      tokenProvider.setToken(token);

      return data;
    }

    return null;
  }

  /// Logout: elimina token del backend y almacenamiento local
  Future<bool> logout() async {
    final currentToken = tokenProvider.token;
    if (currentToken == null) return false;

    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Authorization': 'Bearer $currentToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      tokenProvider.clearToken();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      return true;
    }

    return false;
  }

  /// Verifica si el token actual es válido
  Future<bool> validateToken() async {
    final currentToken = tokenProvider.token;
    if (currentToken == null) return false;

    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Authorization': 'Bearer $currentToken',
        'Accept': 'application/json',
      },
    );

    return response.statusCode == 200;
  }
}
