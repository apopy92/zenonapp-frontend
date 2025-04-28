import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zenon_app/constants.dart';
import 'package:zenon_app/features/galpon/domain/galpon_model.dart';
import 'package:zenon_app/features/auth/data/token_provider.dart';

class GalponService {
  final TokenProvider tokenProvider;

  GalponService({required this.tokenProvider});

  Future<List<Galpon>> obtenerGalponesAsignados() async {
    final token = tokenProvider.token;

    if (token == null) {
      throw Exception('No se encontró token de autenticación');
    }

    final response = await http.get(
      Uri.parse('$apiBaseUrl/galpones'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Galpon.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener galpones: ${response.body}');
    }
  }
}
