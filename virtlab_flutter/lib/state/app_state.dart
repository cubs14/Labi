import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../models/user_profile.dart';
import '../services/achievements_service.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/preferences_service.dart';
import '../theme/colorblind.dart';

/// Estado central de VirtLab: sesión, perfil, personalización y
/// logros. Se expone con Provider para que cualquier pantalla
/// reaccione a cambios (por ejemplo, si cambia el color de fondo en
/// "Personaliza tu experiencia", el Menú se repinta al instante).
class AppState extends ChangeNotifier {
  final AuthService authService = AuthService();
  final FirestoreService firestoreService = FirestoreService();
  final PreferencesService prefsService = PreferencesService();
  final AchievementsService achievementsService = AchievementsService();

  bool loading = true;
  bool loggedIn = false;
  UserProfile? profile;

  // Personalización
  Color backgroundColor = const Color(0xFF9BFAB0);
  Color buttonColor = const Color(0xFF2A8C4A);
  Color textColor = const Color(0xFF15321F);
  double textScale = 1.0;
  ColorBlindMode colorBlindMode = ColorBlindMode.none;

  List<Achievement> achievements = [];
  Achievement? justUnlocked;

  Future<void> bootstrap() async {
    loading = true;
    notifyListeners();

    loggedIn = await prefsService.isLoggedIn();
    final uid = await prefsService.getUid();

    final localPrefs = await prefsService.loadPersonalization();
    _applyPersonalizationMap(localPrefs);

    if (loggedIn && uid != null) {
      profile = await firestoreService.getUserProfile(uid);
      final remotePrefs = await firestoreService.getPersonalization(uid);
      if (remotePrefs != null) _applyPersonalizationMap(remotePrefs);
    }

    achievements = await achievementsService.loadAll(uid);

    loading = false;
    notifyListeners();
  }

  void _applyPersonalizationMap(Map<String, dynamic> map) {
    if (map['backgroundColor'] != null) {
      backgroundColor = Color(map['backgroundColor'] as int);
    }
    if (map['buttonColor'] != null) {
      buttonColor = Color(map['buttonColor'] as int);
    }
    if (map['textColor'] != null) {
      textColor = Color(map['textColor'] as int);
    }
    textScale = (map['textScale'] as num?)?.toDouble() ?? textScale;
    colorBlindMode =
        ColorBlindModeX.fromStorage(map['colorBlindMode'] as String? ?? 'none');
  }

  Future<void> savePersonalization() async {
    await prefsService.savePersonalization(
      backgroundColor: backgroundColor.value,
      buttonColor: buttonColor.value,
      textColor: textColor.value,
      textScale: textScale,
      colorBlindMode: colorBlindMode.name,
    );
    final uid = profile?.uid;
    if (uid != null) {
      await firestoreService.savePersonalization(uid, {
        'backgroundColor': backgroundColor.value,
        'buttonColor': buttonColor.value,
        'textColor': textColor.value,
        'textScale': textScale,
        'colorBlindMode': colorBlindMode.name,
      });
    }
    notifyListeners();
  }

  Future<void> completeLogin(UserProfile userProfile) async {
    profile = userProfile;
    loggedIn = true;
    await prefsService.setSession(loggedIn: true, uid: userProfile.uid);
    achievements = await achievementsService.loadAll(userProfile.uid);
    notifyListeners();
  }

  Future<void> logout() async {
    await authService.signOut();
    await prefsService.setSession(loggedIn: false);
    loggedIn = false;
    profile = null;
    notifyListeners();
  }

  Future<void> unlockAchievement(String id) async {
    final match = achievements.where((a) => a.id == id);
    if (match.isEmpty) return;
    final achievement = match.first;
    final justNow = await achievementsService.unlock(profile?.uid, achievement);
    if (justNow) {
      justUnlocked = achievement;
      notifyListeners();
    }
  }

  void clearJustUnlocked() {
    justUnlocked = null;
  }
}
