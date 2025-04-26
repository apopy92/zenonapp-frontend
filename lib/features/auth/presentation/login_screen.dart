import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_controller.dart';
import 'package:ZenonApp/features/auth/presentation/pages/splash_loading_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LoginController>();
    final formKey = GlobalKey<FormState>();

    if (controller.isLoading) {
      return const SplashLoadingScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEA), // ✅ Color crema suave
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: 'Usuario'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El usuario es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña es requerida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (controller.error != null)
                Text(
                  controller.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final ok = await controller.login(context);
                    if (ok && context.mounted) {
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    }
                  }
                },
                child: const Text('Ingresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
