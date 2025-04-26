import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/auth_service.dart';
import '../../galpon/domain/galpon_model.dart';
import '../../galpon/presentation/galpon_controller.dart';

class LoginController with ChangeNotifier {
  final AuthService _authService;

  LoginController(this._authService);

  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  String? error;
  bool isLoading = false;

  Future<bool> login(BuildContext context) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final String name = nameController.text.trim();
    final String password = passwordController.text.trim();

    if (name.isEmpty || password.isEmpty) {
      error = 'Ambos campos son obligatorios';
      isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final response = await _authService.loginAndGetUser(name, password);

      if (response != null) {
        final galponesJson = response['user']['galpones'] as List<dynamic>;
        final galpones = galponesJson
            .map((g) => Galpon.fromJson(g as Map<String, dynamic>))
            .toList();

        final galponController =
            Provider.of<GalponController>(context, listen: false);
        galponController.setGalpones(galpones);

        return true;
      }

      error = 'Credenciales incorrectas';
      return false;
    } catch (e) {
      error = 'Error inesperado: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    try {
      return await _authService.logout();
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
