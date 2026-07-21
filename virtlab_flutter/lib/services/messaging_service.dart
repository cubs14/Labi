import 'package:firebase_messaging/firebase_messaging.dart';

/// Notificaciones push (Firebase Cloud Messaging).
/// Pide permiso y deja lista la suscripción a un tema de recordatorios
/// diarios. El envío programado en sí (los mensajes 🧪🔬🏆🎯) se
/// dispara desde el backend / Cloud Functions con un cron, ya que FCM
/// no programa notificaciones desde el propio dispositivo cuando la
/// app está completamente cerrada.
class MessagingService {
  final _messaging = FirebaseMessaging.instance;

  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<void> subscribeToDailyReminders() =>
      _messaging.subscribeToTopic('recordatorios_diarios');

  Future<void> unsubscribeFromDailyReminders() =>
      _messaging.unsubscribeFromTopic('recordatorios_diarios');

  Future<String?> getToken() => _messaging.getToken();
}
