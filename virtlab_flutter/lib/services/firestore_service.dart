import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../models/achievement.dart';

/// Acceso a Cloud Firestore.
/// Colecciones:
///   users/{uid}                     -> perfil + personalización
///   users/{uid}/achievements/{id}   -> estado de cada logro
class FirestoreService {
  final _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  Future<void> createUserProfile(UserProfile profile) async {
    await _userDoc(profile.uid).set(profile.toMap(), SetOptions(merge: true));
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    final snap = await _userDoc(uid).get();
    if (!snap.exists) return null;
    return UserProfile.fromMap(uid, snap.data()!);
  }

  Future<void> updatePhotoUrl(String uid, String photoUrl) async {
    await _userDoc(uid).set({'photoUrl': photoUrl}, SetOptions(merge: true));
  }

  Future<void> addXp(String uid, int xpGained) async {
    await _db.runTransaction((tx) async {
      final ref = _userDoc(uid);
      final snap = await tx.get(ref);
      final currentXp = (snap.data()?['xp'] as num?)?.toInt() ?? 0;
      final currentLevel = (snap.data()?['level'] as num?)?.toInt() ?? 1;
      final newXp = currentXp + xpGained;
      // 100 XP por nivel, sencillo y predecible.
      final newLevel = 1 + (newXp ~/ 100);
      tx.set(ref, {'xp': newXp, 'level': newLevel}, SetOptions(merge: true));
    });
  }

  Future<void> savePersonalization(String uid, Map<String, dynamic> prefs) async {
    await _userDoc(uid).set({'personalization': prefs}, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getPersonalization(String uid) async {
    final snap = await _userDoc(uid).get();
    return snap.data()?['personalization'] as Map<String, dynamic>?;
  }

  // ---- Logros ----

  Future<void> upsertAchievementState(String uid, Achievement a) async {
    await _userDoc(uid)
        .collection('achievements')
        .doc(a.id)
        .set(a.toMap(), SetOptions(merge: true));
  }

  Future<Map<String, Map<String, dynamic>>> getAllAchievementStates(String uid) async {
    final snap = await _userDoc(uid).collection('achievements').get();
    return {for (final d in snap.docs) d.id: d.data()};
  }
}
