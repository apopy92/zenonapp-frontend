import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenon_app/features/auth/presentation/login_controller.dart';

class ZenonAppDrawer extends StatelessWidget {
  const ZenonAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Encabezado del Drawer
          const DrawerHeader(
            child: Text('Bienvenido'),
          ),
          // Elementos del menú
          ListTile(
            title: const Text('Cerrar sesión'),
            onTap: () async {
              // Limpiar el token y redirigir al login
              final loginController =
                  Provider.of<LoginController>(context, listen: false);
              await loginController.logout();

              // Verifica que el contexto esté montado antes de hacer la navegación
              if (context.mounted) {
                Navigator.pushReplacementNamed(
                    context, '/login'); // Redirigir a login
              }
            },
          ),
        ],
      ),
    );
  }
}
