import 'package:flutter/material.dart';
import 'package:zenon_app/features/auth/presentation/pages/login_page.dart';
import 'package:zenon_app/features/auth/presentation/pages/login_success_screen.dart'; // ✅ nuevo import
import 'package:zenon_app/pages/dashboard_page.dart';
import 'package:zenon_app/pages/gasto_page.dart';
import 'package:zenon_app/pages/mortandad_page.dart';
import 'package:zenon_app/pages/produccion_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String loginSuccess = '/login-success'; // ✅ nueva constante
  static const String dashboard = '/dashboard';
  static const String produccion = '/produccion';
  static const String gasto = '/gasto';
  static const String mortandad = '/mortandad';

  static final Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    loginSuccess: (_) => const LoginSuccessScreen(), // ✅ nueva ruta
    dashboard: (_) => const DashboardPage(),
    produccion: (_) => const ProduccionPage(),
    gasto: (_) => const GastoPage(),
    mortandad: (_) => const MortandadPage(),
  };
}
