import 'package:firebase_auth/firebase_auth.dart';

/// Envoltorio sobre Firebase Authentication.
/// Traduce los FirebaseAuthException a mensajes amigables en español,
/// tal como pide la pantalla de Inicio de Sesión original.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_friendlyMessage(e));
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_friendlyMessage(e));
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_friendlyMessage(e));
    }
  }

  Future<void> signOut() => _auth.signOut();

  String _friendlyMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'user-not-found':
        return 'No encontramos una cuenta con ese correo.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con ese correo.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      case 'network-request-failed':
        return 'Sin conexión a internet. Inténtalo de nuevo.';
      default:
        return 'Ocurrió un error. Inténtalo de nuevo.';
    }
  }
}

class AuthFailure implements Exception {
  final String message;
  AuthFailure(this.message);
  @override
  String toString() => message;
}
