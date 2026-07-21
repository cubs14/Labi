import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'welcome_screen.dart';
import 'menu_screen.dart';

/// Splash Screen del NUEVO FLUJO: mientras se decide si hay sesión
/// activa (SharedPreferences) o no, se muestra el logo con una
/// animación suave.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _bootstrapAndNavigate();
  }

  Future<void> _bootstrapAndNavigate() async {
    final state = context.read<AppState>();
    await state.bootstrap();
    // Deja ver el splash un instante mínimo aunque bootstrap sea rápido.
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => state.loggedIn ? const MenuScreen() : const WelcomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/virtlab.png', height: 160),
                const SizedBox(height: 16),
                const Text(
                  'VirtLab',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 24),
                const CircularProgressIndicator(color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
