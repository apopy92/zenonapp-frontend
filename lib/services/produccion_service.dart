import 'dart:convert';
import 'package:http/http.dart' as http;

class ProduccionService {
  static const String baseUrl =
      'http://tu-backend-url.com/api'; // <-- reemplaza por tu dominio real

  static Future<bool> registrarProduccion({
    required int galponId,
    required DateTime fecha,
    required int cantidad,
    required String tipo,
    String? observaciones,
  }) async {
    final url = Uri.parse('$baseUrl/producciones');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'galpon_id': galponId,
        'fecha': fecha.toIso8601String(),
        'cantidad': cantidad,
        'tipo': tipo,
        'observaciones': observaciones ?? '',
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Error: ${response.body}');
      return false;
    }
  }
}
