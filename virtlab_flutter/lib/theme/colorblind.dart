import 'package:flutter/material.dart';

enum ColorBlindMode { none, deuteranopia, protanopia, tritanopia, acromatopsia }

extension ColorBlindModeX on ColorBlindMode {
  String get label {
    switch (this) {
      case ColorBlindMode.none:
        return 'Ninguno';
      case ColorBlindMode.deuteranopia:
        return 'Deuteranopia';
      case ColorBlindMode.protanopia:
        return 'Protanopia';
      case ColorBlindMode.tritanopia:
        return 'Tritanopia';
      case ColorBlindMode.acromatopsia:
        return 'Acromatopsia';
    }
  }

  static ColorBlindMode fromStorage(String value) {
    return ColorBlindMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => ColorBlindMode.none,
    );
  }

  /// Matrices de simulación/compensación de daltonismo (aproximación
  /// estándar tipo Brettel/Viénot, usadas ampliamente en apps móviles).
  List<double>? get colorMatrix {
    switch (this) {
      case ColorBlindMode.none:
        return null;
      case ColorBlindMode.deuteranopia:
        return [
          0.625, 0.375, 0, 0, 0,
          0.7, 0.3, 0, 0, 0,
          0, 0.3, 0.7, 0, 0,
          0, 0, 0, 1, 0,
        ];
      case ColorBlindMode.protanopia:
        return [
          0.567, 0.433, 0, 0, 0,
          0.558, 0.442, 0, 0, 0,
          0, 0.242, 0.758, 0, 0,
          0, 0, 0, 1, 0,
        ];
      case ColorBlindMode.tritanopia:
        return [
          0.95, 0.05, 0, 0, 0,
          0, 0.433, 0.567, 0, 0,
          0, 0.475, 0.525, 0, 0,
          0, 0, 0, 1, 0,
        ];
      case ColorBlindMode.acromatopsia:
        return [
          0.299, 0.587, 0.114, 0, 0,
          0.299, 0.587, 0.114, 0, 0,
          0.299, 0.587, 0.114, 0, 0,
          0, 0, 0, 1, 0,
        ];
    }
  }
}

/// Envuelve toda la app para aplicar el filtro de color elegido en
/// "Personaliza tu experiencia".
class ColorBlindFilter extends StatelessWidget {
  final ColorBlindMode mode;
  final Widget child;
  const ColorBlindFilter({super.key, required this.mode, required this.child});

  @override
  Widget build(BuildContext context) {
    final matrix = mode.colorMatrix;
    if (matrix == null) return child;
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(matrix),
      child: child,
    );
  }
}
