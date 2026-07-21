import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'personalize_screen.dart';

/// Pantalla "Crear cuenta": nombre completo, usuario, correo,
/// contraseña + confirmación, fecha de nacimiento, país, departamento,
/// municipio y foto de perfil (cámara/galería, o avatar científico
/// automático si no se selecciona ninguna).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthDate = TextEditingController();
  final _country = TextEditingController();
  final _department = TextEditingController();
  final _municipality = TextEditingController();

  final _storageService = StorageService();

  File? _photo;
  bool _loading = false;
  String? _error;

  /// Avatar científico por defecto cuando el usuario no elige foto.
  static const _defaultAvatar = 'assets/images/virtlab.png';

  Future<void> _pickPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, maxWidth: 800, imageQuality: 85);
    if (file != null) setState(() => _photo = File(file.path));
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 15),
      firstDate: DateTime(1930),
      lastDate: now,
    );
    if (picked != null) {
      _birthDate.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_password.text != _confirm.text) {
      setState(() => _error = 'Las contraseñas no coinciden.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final state = context.read<AppState>();
    try {
      final user = await state.authService.register(_email.text, _password.text);
      if (user == null) throw Exception('No se pudo crear la cuenta.');

      String photoUrl;
      if (_photo != null) {
        photoUrl = await _storageService.uploadProfilePhoto(user.uid, _photo!);
      } else {
        photoUrl = _defaultAvatar;
      }

      final profile = UserProfile(
        uid: user.uid,
        fullName: _fullName.text.trim(),
        username: _username.text.trim(),
        email: _email.text.trim(),
        birthDate: _birthDate.text.trim(),
        country: _country.text.trim(),
        department: _department.text.trim(),
        municipality: _municipality.text.trim(),
        photoUrl: photoUrl,
      );
      await state.firestoreService.createUserProfile(profile);
      await state.completeLogin(profile);

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const PersonalizeScreen(firstTime: true)),
        (route) => false,
      );
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => _showPhotoOptions(context),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white,
                      backgroundImage: _photo != null ? FileImage(_photo!) : null,
                      child: _photo == null
                          ? const Icon(Icons.add_a_photo_outlined, size: 32, color: AppColors.primaryDark)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Toca para tomar o elegir una foto\n(si no eliges una, te asignamos un avatar)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.textDark),
                  ),
                ),
                const SizedBox(height: 20),
                _field(_fullName, 'Nombre completo'),
                _field(_username, 'Nombre de usuario'),
                _field(_email, 'Correo electrónico', keyboardType: TextInputType.emailAddress),
                _field(_password, 'Contraseña', obscure: true),
                _field(_confirm, 'Confirmar contraseña', obscure: true),
                TextFormField(
                  controller: _birthDate,
                  readOnly: true,
                  onTap: _pickBirthDate,
                  decoration: const InputDecoration(labelText: 'Fecha de nacimiento', filled: true, fillColor: Colors.white),
                  validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),
                _field(_country, 'País'),
                _field(_department, 'Departamento'),
                _field(_municipality, 'Municipio'),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Crear cuenta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, {bool obscure = false, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, filled: true, fillColor: Colors.white),
        validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
      ),
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tomar fotografía'),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir desde la galería'),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
