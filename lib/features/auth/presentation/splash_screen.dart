import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ZenonApp/constants.dart';
import 'package:ZenonApp/features/auth/data/auth_service.dart';
import 'package:ZenonApp/features/auth/data/token_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(
      baseUrl: apiBaseUrl,
      tokenProvider: Provider.of<TokenProvider>(context, listen: false),
    );
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await _authService.loadToken();
    final isValid = await _authService.validateToken();

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      isValid ? '/dashboard' : '/login',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
