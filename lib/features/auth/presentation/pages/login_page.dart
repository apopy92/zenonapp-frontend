import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:zenon_app/core/routes/app_routes.dart';
import '../login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEA),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: controller.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (controller.error != null)
                      Text(
                        controller.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading
                            ? null
                            : () async {
                                final success = await controller.login(context);
                                if (success && context.mounted) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.dashboard,
                                  );
                                }
                              },
                        child: const Text('Ingresar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (controller.isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Fondo translúcido
              child: Center(
                child: Lottie.asset(
                  'assets/animations/gallina.json',
                  width: 200,
                  repeat: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
