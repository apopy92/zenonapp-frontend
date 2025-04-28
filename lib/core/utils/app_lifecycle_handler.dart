import 'package:flutter/material.dart';
import 'package:zenon_app/features/auth/data/auth_service.dart';
import 'package:zenon_app/core/routes/app_routes.dart';

class AppLifecycleHandler extends WidgetsBindingObserver {
  final AuthService authService;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  DateTime? _pausedAt;

  AppLifecycleHandler(this.authService);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_pausedAt != null) {
        final duration = DateTime.now().difference(_pausedAt!);

        if (duration.inMinutes >= 10) {
          _handleSessionExpired();
        }
      }
    }
  }

  Future<void> _handleSessionExpired() async {
    await authService.logout();

    final context = navigatorKey.currentContext;
    if (context != null) {
      // Mostrar SnackBar informando que expiró la sesión
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              '⏳ Tu sesión ha expirado. Por favor vuelve a iniciar sesión.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 4),
        ),
      );

      // Redirigir al login después de mostrar el mensaje
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    }
  }
}
