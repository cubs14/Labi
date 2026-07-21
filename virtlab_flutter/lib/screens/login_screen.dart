import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'personalize_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final state = context.read<AppState>();
    try {
      final user = await state.authService.signIn(_emailCtrl.text, _passCtrl.text);
      if (user == null) throw Exception('No se pudo iniciar sesión.');
      var profile = await state.firestoreService.getUserProfile(user.uid);
      profile ??= UserProfile(
        uid: user.uid,
        fullName: user.displayName ?? '',
        username: user.email?.split('@').first ?? '',
        email: user.email ?? '',
        birthDate: '',
        country: '',
        department: '',
        municipality: '',
        photoUrl: user.photoURL ?? '',
      );
      await state.completeLogin(profile);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const PersonalizeScreen(firstTime: false)),
        (route) => false,
      );
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    if (_emailCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Escribe tu correo para poder enviarte el enlace.');
      return;
    }
    try {
      await context.read<AppState>().authService.sendPasswordReset(_emailCtrl.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Te enviamos un correo para restablecer tu contraseña.')),
      );
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Iniciar sesión',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Correo electrónico', filled: true, fillColor: Colors.white),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Ingresa un correo válido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña', filled: true, fillColor: Colors.white),
                  validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Iniciar sesión'),
                ),
                const SizedBox(height: 12),
                TextButton(onPressed: _forgotPassword, child: const Text('¿Olvidaste tu contraseña?')),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  child: const Text('Crear cuenta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
