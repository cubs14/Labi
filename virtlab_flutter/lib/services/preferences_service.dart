import 'package:shared_preferences/shared_preferences.dart';

/// Envoltorio sobre SharedPreferences. Guarda:
/// - Si hay sesión activa (para saltar Login/Registro/Personalización
///   en próximos arranques, tal como pide el flujo original).
/// - Las preferencias de personalización, para poder pintar la UI
///   incluso sin conexión antes de sincronizar con Firestore.
class PreferencesService {
  static const _kLoggedIn = 'logged_in';
  static const _kUid = 'uid';
  static const _kBgColor = 'pref_bg_color';
  static const _kButtonColor = 'pref_button_color';
  static const _kTextColor = 'pref_text_color';
  static const _kTextScale = 'pref_text_scale';
  static const _kColorBlindMode = 'pref_colorblind_mode';
  static const _kNotificationsEnabled = 'pref_notifications_enabled';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<bool> isLoggedIn() async => (await _prefs).getBool(_kLoggedIn) ?? false;

  Future<void> setSession({required bool loggedIn, String? uid}) async {
    final p = await _prefs;
    await p.setBool(_kLoggedIn, loggedIn);
    if (uid != null) await p.setString(_kUid, uid);
    if (!loggedIn) await p.remove(_kUid);
  }

  Future<String?> getUid() async => (await _prefs).getString(_kUid);

  // ---- Personalización ----

  Future<void> savePersonalization({
    required int backgroundColor,
    required int buttonColor,
    required int textColor,
    required double textScale,
    required String colorBlindMode,
  }) async {
    final p = await _prefs;
    await p.setInt(_kBgColor, backgroundColor);
    await p.setInt(_kButtonColor, buttonColor);
    await p.setInt(_kTextColor, textColor);
    await p.setDouble(_kTextScale, textScale);
    await p.setString(_kColorBlindMode, colorBlindMode);
  }

  Future<Map<String, dynamic>> loadPersonalization() async {
    final p = await _prefs;
    return {
      'backgroundColor': p.getInt(_kBgColor),
      'buttonColor': p.getInt(_kButtonColor),
      'textColor': p.getInt(_kTextColor),
      'textScale': p.getDouble(_kTextScale) ?? 1.0,
      'colorBlindMode': p.getString(_kColorBlindMode) ?? 'none',
    };
  }

  Future<bool> notificationsEnabled() async =>
      (await _prefs).getBool(_kNotificationsEnabled) ?? true;

  Future<void> setNotificationsEnabled(bool value) async {
    final p = await _prefs;
    await p.setBool(_kNotificationsEnabled, value);
  }

  Future<void> clearSessionOnly() async {
    final p = await _prefs;
    await p.remove(_kLoggedIn);
    await p.remove(_kUid);
    // Nota: se conserva la personalización a propósito; solo se borra
    // por completo si el usuario desinstala o borra datos de la app.
  }
}
