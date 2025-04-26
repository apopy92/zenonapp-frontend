import 'package:flutter/widgets.dart';
import 'package:ZenonApp/features/auth/data/auth_service.dart';

class AppLifecycleHandler extends WidgetsBindingObserver {
  final AuthService authService;

  AppLifecycleHandler(this.authService);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _logoutIfTokenExists();
    }
  }

  Future<void> _logoutIfTokenExists() async {
    await authService.loadToken();
    if (authService.token != null) {
      await authService.logout();
      debugPrint('🔐 Token revocado automáticamente al cerrar la app');
    }
  }
}
