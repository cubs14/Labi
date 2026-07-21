import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';
import '../data/achievements_data.dart';
import 'firestore_service.dart';

/// Maneja el desbloqueo de logros con copia local (para funcionar sin
/// conexión) y sincronización automática a Firestore cuando hay
/// internet, tal como pide la sección "Sistema de logros":
/// el usuario nunca debe perder sus logros aunque cambie de
/// dispositivo, y deben guardar estado, fecha, XP y progreso.
class AchievementsService {
  static const _kLocalKey = 'achievements_state';
  final FirestoreService _firestore = FirestoreService();

  Future<List<Achievement>> loadAll(String? uid) async {
    final achievements = buildDefaultAchievements();
    final prefs = await SharedPreferences.getInstance();

    // 1. Aplicar copia local primero (funciona offline).
    final raw = prefs.getString(_kLocalKey);
    if (raw != null) {
      final Map<String, dynamic> local = jsonDecode(raw);
      for (final a in achievements) {
        final state = local[a.id] as Map<String, dynamic>?;
        if (state != null) a.applyState(state);
      }
    }

    // 2. Si hay sesión, intentar traer/mezclar con Firestore.
    if (uid != null) {
      try {
        final remote = await _firestore.getAllAchievementStates(uid);
        for (final a in achievements) {
          final state = remote[a.id];
          if (state != null) {
            // Se conserva el desbloqueo si cualquiera de las dos
            // copias (local o remota) ya lo tenía en true.
            final remoteUnlocked = state['unlocked'] as bool? ?? false;
            if (remoteUnlocked || a.unlocked) {
              a.applyState(state);
              a.unlocked = true;
            }
          }
        }
        await _persistLocal(achievements);
      } catch (_) {
        // Sin conexión: seguimos con la copia local únicamente.
      }
    }
    return achievements;
  }

  /// Desbloquea un logro si no lo estaba. Devuelve true si se acaba
  /// de desbloquear ahora mismo (para disparar la notificación).
  Future<bool> unlock(String? uid, Achievement achievement) async {
    if (achievement.unlocked) return false;
    achievement.unlocked = true;
    achievement.unlockedAt = DateTime.now();
    achievement.progress = 1.0;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kLocalKey);
    final Map<String, dynamic> local = raw != null ? jsonDecode(raw) : {};
    local[achievement.id] = achievement.toMap();
    await prefs.setString(_kLocalKey, jsonEncode(local));

    if (uid != null) {
      try {
        await _firestore.upsertAchievementState(uid, achievement);
        await _firestore.addXp(uid, achievement.xp);
      } catch (_) {
        // Se sincronizará más adelante: queda guardado localmente.
      }
    }
    return true;
  }

  Future<void> _persistLocal(List<Achievement> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    final map = {for (final a in achievements) a.id: a.toMap()};
    await prefs.setString(_kLocalKey, jsonEncode(map));
  }
}
