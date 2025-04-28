import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenon_app/constants.dart';
import 'package:zenon_app/core/routes/app_routes.dart';
import 'package:zenon_app/core/utils/app_lifecycle_handler.dart';
import 'package:zenon_app/features/auth/data/auth_service.dart';
import 'package:zenon_app/features/auth/data/token_provider.dart';
import 'package:zenon_app/features/auth/presentation/login_controller.dart';
import 'package:zenon_app/features/galpon/presentation/galpon_controller.dart';
import 'package:zenon_app/features/auth/presentation/pages/splash_loading_screen.dart';
import 'package:zenon_app/features/produccion/presentation/produccion_controller.dart';
import 'package:zenon_app/features/mortandad/presentation/mortandad_controller.dart';
import 'package:zenon_app/features/gasto/presentation/gasto_controller.dart';

void main() {
  runApp(const GranjaApp());
}

class GranjaApp extends StatelessWidget {
  const GranjaApp({super.key});

  Future<void> _clearSession(AuthService authService) async {
    await authService.logout();
  }

  @override
  Widget build(BuildContext context) {
    final tokenProvider = TokenProvider();
    final authService = AuthService(
      baseUrl: apiBaseUrl,
      tokenProvider: tokenProvider,
    );

    WidgetsBinding.instance.addObserver(AppLifecycleHandler(authService));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => tokenProvider),
        ChangeNotifierProvider(create: (_) => LoginController(authService)),
        ChangeNotifierProxyProvider<TokenProvider, GalponController>(
          create: (_) => GalponController(tokenProvider: tokenProvider),
          update: (_, tokenProvider, __) =>
              GalponController(tokenProvider: tokenProvider),
        ),
        ChangeNotifierProxyProvider2<GalponController, TokenProvider,
            ProduccionController>(
          create: (_) => ProduccionController(
            galponController: GalponController(tokenProvider: tokenProvider),
            tokenProvider: tokenProvider,
          ),
          update: (_, galponController, tokenProvider, __) =>
              ProduccionController(
            galponController: galponController,
            tokenProvider: tokenProvider,
          ),
        ),
        ChangeNotifierProxyProvider2<GalponController, TokenProvider,
            MortandadController>(
          create: (_) => MortandadController(
            galponController: GalponController(tokenProvider: tokenProvider),
            tokenProvider: tokenProvider,
          ),
          update: (_, galponController, tokenProvider, __) =>
              MortandadController(
            galponController: galponController,
            tokenProvider: tokenProvider,
          ),
        ),
        ChangeNotifierProxyProvider2<GalponController, TokenProvider,
            GastoController>(
          create: (_) => GastoController(
            galponController: GalponController(tokenProvider: tokenProvider),
            tokenProvider: tokenProvider,
          ),
          update: (_, galponController, tokenProvider, __) => GastoController(
            galponController: galponController,
            tokenProvider: tokenProvider,
          ),
        ),
      ],
      child: FutureBuilder<void>(
        future: _clearSession(authService),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const MaterialApp(
              home: SplashLoadingScreen(),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ZenonApp',
            navigatorKey: AppLifecycleHandler.navigatorKey, // 👈 Agregado
            theme: ThemeData(
              primarySwatch: Colors.orange,
              scaffoldBackgroundColor: const Color(0xFFFCEFD9),
            ),
            initialRoute: AppRoutes.login,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
