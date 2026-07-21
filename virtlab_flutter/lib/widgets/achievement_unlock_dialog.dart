import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/achievement.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Notificación elegante de logro desbloqueado: 🏆, felicitaciones con
/// el nombre del usuario (tomado del perfil), nombre del logro,
/// ícono y botón "Ver logro". No se vuelve a mostrar para un logro ya
/// desbloqueado porque AchievementsService.unlock() solo dispara
/// justUnlocked la primera vez.
class AchievementUnlockListener extends StatelessWidget {
  final Widget child;
  const AchievementUnlockListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final achievement = state.justUnlocked;
        if (achievement != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showDialog(context, state, achievement);
          });
        }
        return child;
      },
    );
  }

  void _showDialog(BuildContext context, AppState state, Achievement achievement) {
    state.clearJustUnlocked();
    final userName = state.profile?.fullName.split(' ').first ?? 'científico/a';
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'logro',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, __, ___) {
        return Transform.scale(
          scale: Curves.elasticOut.transform(anim.value),
          child: Opacity(
            opacity: anim.value.clamp(0.0, 1.0),
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    Text('¡Felicidades, $userName!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Has desbloqueado un nuevo logro.', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    Image.asset(achievement.iconColorAsset, width: 80, height: 80),
                    const SizedBox(height: 8),
                    Text(achievement.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Ver logro'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
