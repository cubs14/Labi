import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';

/// Pantalla Bienvenida: logo, nombre, lema, botones Iniciar sesión /
/// Crear cuenta y el texto de progreso, igual a la especificación.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/virtlab.png', height: 150),
              const SizedBox(height: 20),
              const Text(
                'VirtLab',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Descubrir, experimentar y comprender.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: const Text('Iniciar sesión'),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: const BorderSide(color: AppColors.primaryDark, width: 1.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    'Crear cuenta',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Continúa para guardar tu progreso, logros y experimentos.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textDark, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
