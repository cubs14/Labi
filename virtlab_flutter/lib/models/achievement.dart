/// Logro de VirtLab.
///
/// En el proyecto original (Kodular) existían más íconos de logros
/// (logro1, logro4-10, "nuevo", "secreto" en color y gris) que
/// definiciones reales: solo 5 logros tenían tarjeta, texto y lógica
/// de desbloqueo en la pantalla Logros. Aquí se completan esos 5 con
/// su lógica real de desbloqueo, respetando exactamente su
/// descripción original. Los íconos sobrantes quedan disponibles en
/// assets/images/logros/ para cuando el equipo defina logros nuevos
/// con nombre y condición reales — no se inventó contenido para ellos.
class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconColorAsset;
  final String iconGrayAsset;
  final int xp;

  bool unlocked;
  DateTime? unlockedAt;
  double progress; // 0.0 - 1.0

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconColorAsset,
    required this.iconGrayAsset,
    required this.xp,
    this.unlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'unlocked': unlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
        'progress': progress,
      };

  void applyState(Map<String, dynamic> state) {
    unlocked = state['unlocked'] as bool? ?? unlocked;
    progress = (state['progress'] as num?)?.toDouble() ?? progress;
    final ts = state['unlockedAt'] as String?;
    if (ts != null) unlockedAt = DateTime.tryParse(ts);
  }
}
