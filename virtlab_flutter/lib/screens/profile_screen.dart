import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'welcome_screen.dart';

/// Pantalla Perfil: foto, nombre, correo, fecha de nacimiento, país,
/// nivel, XP, total de logros, botón para editar foto y botón de
/// cerrar sesión (que regresa a Inicio de Sesión), igual a la
/// especificación. Mantiene el mismo estilo visual del resto de la
/// app (no es una pantalla nativa aparte).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = StorageService();
  bool _uploading = false;

  Future<void> _editPhoto(ImageSource source) async {
    final state = context.read<AppState>();
    final profile = state.profile;
    if (profile == null) return;
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, maxWidth: 800, imageQuality: 85);
    if (file == null) return;
    setState(() => _uploading = true);
    try {
      final url = await _storage.uploadProfilePhoto(profile.uid, File(file.path));
      await state.firestoreService.updatePhotoUrl(profile.uid, url);
      state.profile = profile.copyWith(photoUrl: url);
      state.notifyListeners();
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.pop(context);
                _editPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galería'),
              onTap: () {
                Navigator.pop(context);
                _editPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final profile = state.profile;
    final unlockedCount = state.achievements.where((a) => a.unlocked).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: profile == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.white,
                          backgroundImage: profile.photoUrl.startsWith('http')
                              ? NetworkImage(profile.photoUrl)
                              : AssetImage(profile.photoUrl) as ImageProvider,
                        ),
                        if (_uploading)
                          const Positioned.fill(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton.icon(
                      onPressed: _showPhotoOptions,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Editar foto de perfil'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _infoRow('Nombre completo', profile.fullName),
                  _infoRow('Correo electrónico', profile.email),
                  _infoRow('Fecha de nacimiento', profile.birthDate),
                  _infoRow('País', profile.country),
                  _infoRow('Nivel', profile.level.toString()),
                  _infoRow('XP', profile.xp.toString()),
                  _infoRow('Logros obtenidos', '$unlockedCount / ${state.achievements.length}'),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await state.logout();
                        if (!context.mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          Text(value.isEmpty ? '—' : value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
