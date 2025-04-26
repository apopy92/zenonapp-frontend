import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashDialogLoading extends StatelessWidget {
  const SplashDialogLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 240,
        maxHeight: 280,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ Se adapta al contenido
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Lottie.asset(
              'assets/animations/gallina.json',
              width: 140,
              height: 140,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Cerrando sesión...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.brown,
            ),
          ),
        ],
      ),
    );
  }
}
