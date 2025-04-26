import 'package:flutter/material.dart';

import '../pages/dashboard_page.dart';
import '../pages/produccion_page.dart';
import '../pages/gasto_page.dart';
import '../pages/mortandad_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Granja App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFFCEFD9),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardPage(),
        '/produccion': (context) => const ProduccionPage(),
        '/gastos': (context) => const GastoPage(),
        '/mortandad': (context) => const MortandadPage(),
      },
    );
  }
}
