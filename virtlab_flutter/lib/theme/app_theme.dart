import 'package:flutter/material.dart';

/// Paleta extraída directamente del proyecto original de Kodular.
/// Fondo: &HFF9BFAB0  |  Botones: &HFF2A8C4A
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF9BFAB0); // verde menta
  static const Color backgroundDark = Color(0xFF6FE097);
  static const Color primary = Color(0xFF2A8C4A); // verde botones
  static const Color primaryDark = Color(0xFF1E6636);
  static const Color textOnPrimary = Colors.white;
  static const Color textDark = Color(0xFF15321F);
  static const Color card = Colors.white;
  static const Color accentGold = Color(0xFFE0B23B); // para logros
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.card,
      ),
      fontFamily: 'Roboto',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4,
        ),
      ),
    );
  }
}
