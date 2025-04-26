import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ZenonApp/constants.dart';
import 'package:ZenonApp/core/routes/app_routes.dart';
import 'package:ZenonApp/core/utils/app_lifecycle_handler.dart';
import 'package:ZenonApp/features/auth/data/auth_service.dart';
import 'package:ZenonApp/features/auth/data/token_provider.dart';
import 'package:ZenonApp/features/auth/presentation/login_controller.dart';
import 'package:ZenonApp/features/galpon/presentation/galpon_controller.dart';
import 'package:ZenonApp/features/auth/presentation/pages/splash_loading_screen.dart';
import 'package:ZenonApp/features/produccion/presentation/produccion_controller.dart';
import 'package:ZenonApp/features/mortandad/presentation/mortandad_controller.dart';
import 'package:ZenonApp/features/gasto/presentation/gasto_controller.dart';

void main() {
  runApp(const GranjaApp());
}

class GranjaApp extends StatelessWidget {
  const GranjaApp({super.key});

  Future<Map<String, dynamic>> _initApp(AuthService authService) async {
    await authService.loadToken();
    final isValid = await authService.validateToken();
    return {
      'isAuthenticated': isValid,
      'token': authService.token,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tokenProvider = TokenProvider();
    final authService = AuthService(
      baseUrl: apiBaseUrl,
      tokenProvider: tokenProvider,
    );

    WidgetsBinding.instance.addObserver(AppLifecycleHandler(authService));

    return FutureBuilder<Map<String, dynamic>>(
      future: _initApp(authService),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: SplashLoadingScreen(),
          );
        }

        final isAuthenticated = snapshot.data?['isAuthenticated'] == true;
        final token = snapshot.data?['token'];
        final initialRoute =
            isAuthenticated ? AppRoutes.dashboard : AppRoutes.login;

        if (token != null) {
          tokenProvider.setToken(token);
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => tokenProvider),
            ChangeNotifierProvider(create: (_) => LoginController(authService)),

            // GalponController ahora depende de TokenProvider
            ChangeNotifierProxyProvider<TokenProvider, GalponController>(
              create: (_) => GalponController(tokenProvider: tokenProvider),
              update: (_, tokenProvider, __) =>
                  GalponController(tokenProvider: tokenProvider),
            ),

            // Producción
            ChangeNotifierProxyProvider2<GalponController, TokenProvider,
                ProduccionController>(
              create: (_) => ProduccionController(
                galponController:
                    GalponController(tokenProvider: tokenProvider),
                tokenProvider: tokenProvider,
              ),
              update: (_, galponController, tokenProvider, __) =>
                  ProduccionController(
                galponController: galponController,
                tokenProvider: tokenProvider,
              ),
            ),

            // Mortandad
            ChangeNotifierProxyProvider2<GalponController, TokenProvider,
                MortandadController>(
              create: (_) => MortandadController(
                galponController:
                    GalponController(tokenProvider: tokenProvider),
                tokenProvider: tokenProvider,
              ),
              update: (_, galponController, tokenProvider, __) =>
                  MortandadController(
                galponController: galponController,
                tokenProvider: tokenProvider,
              ),
            ),

            // Gasto
            ChangeNotifierProxyProvider2<GalponController, TokenProvider,
                GastoController>(
              create: (_) => GastoController(
                galponController:
                    GalponController(tokenProvider: tokenProvider),
                tokenProvider: tokenProvider,
              ),
              update: (_, galponController, tokenProvider, __) =>
                  GastoController(
                galponController: galponController,
                tokenProvider: tokenProvider,
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ZenonApp',
            theme: ThemeData(
              primarySwatch: Colors.orange,
              scaffoldBackgroundColor: const Color(0xFFFCEFD9),
            ),
            initialRoute: initialRoute,
            routes: AppRoutes.routes,
          ),
        );
      },
    );
  }
}
