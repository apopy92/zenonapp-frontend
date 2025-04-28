import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zenon_app/constants.dart';
import 'package:zenon_app/features/galpon/presentation/galpon_controller.dart';
import 'package:zenon_app/features/auth/data/token_provider.dart';

class GastoController with ChangeNotifier {
  final GalponController galponController;
  final TokenProvider tokenProvider;

  GastoController({
    required this.galponController,
    required this.tokenProvider,
  });

  bool isLoading = false;

  Future<void> guardarGasto({
    required BuildContext context,
    required int cantidad,
    required String descripcion,
    required DateTime fecha,
  }) async {
    final galponId = galponController.galponIdSeleccionado;
    final token = tokenProvider.token;

    if (galponId == null || token == null) {
      _showSnack(context, '⚠️ Token o galpón no disponibles');
      return;
    }

    final datos = {
      'galpon_id': galponId,
      'fecha': fecha.toIso8601String().split('T').first,
      'monto': cantidad,
      'concepto': descripcion,
    };

    final url = Uri.parse('$apiBaseUrl/gastos');

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: jsonEncode(datos),
      );

      if (response.statusCode == 201) {
        if (!context.mounted) return;

        _showSnack(
          context,
          '✅ Gasto registrado correctamente',
          success: true,
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (route) => false,
        );
      } else {
        _showSnack(context, 'Error del servidor: ${response.body}');
      }
    } catch (e) {
      _showSnack(context, 'Error de conexión con el servidor');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showSnack(BuildContext context, String message,
      {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : null,
      ),
    );
  }
}
