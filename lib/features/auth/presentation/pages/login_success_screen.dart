import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginSuccessScreen extends StatelessWidget {
  const LoginSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFCEFD9),
      body: Center(
        child: Lottie.asset(
          'assets/animations/gallina.json',
          width: 200,
          repeat: false,
        ),
      ),
    );
  }
}
