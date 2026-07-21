import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Sube fotos de perfil a Firebase Storage y devuelve la URL pública,
/// tal como pide la sección "Crear cuenta" / "Editar foto de perfil".
class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadProfilePhoto(String uid, File file) async {
    final ref = _storage.ref().child('profile_photos/$uid.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}
