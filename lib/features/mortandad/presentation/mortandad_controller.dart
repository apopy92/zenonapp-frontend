import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ZenonApp/constants.dart';
import 'package:ZenonApp/features/galpon/presentation/galpon_controller.dart';
import 'package:ZenonApp/features/auth/data/token_provider.dart';

class MortandadController with ChangeNotifier {
  final GalponController galponController;
  final TokenProvider tokenProvider;

  MortandadController({
    required this.galponController,
    required this.tokenProvider,
  });

  bool isLoading = false;

  Future<void> guardarMortandad({
    required BuildContext context,
    required int cantidad,
    required String causa,
    required DateTime fecha,
  }) async {
    final galponId = galponController.galponIdSeleccionado;
    final token = tokenProvider.token;

    if (galponId == null || token == null) {
      _showSnack(context,
          '⚠️ No se pudo enviar. ${token == null ? "Token" : ""}${token == null && galponId == null ? " y " : ""}${galponId == null ? "Galpón" : ""} no disponibles.');
      return;
    }

    final body = {
      'galpon_id': galponId,
      'fecha': fecha.toIso8601String().split('T').first,
      'cantidad': cantidad,
      'causa': causa,
    };

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/mortandades'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        if (!context.mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (route) => false,
        );

        _showSnack(
          context,
          '✅ Mortandad registrada correctamente',
          success: true,
        );
      } else {
        _showSnack(context, '❌ Error del servidor: ${response.body}');
      }
    } catch (e) {
      _showSnack(context, '❌ Error de conexión: $e');
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
        backgroundColor: success ? Colors.green : Colors.red[400],
      ),
    );
  }
}
