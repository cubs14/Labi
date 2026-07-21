import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Tarjeta de acceso a una ciencia (o a Logros / Acerca de).
/// Reemplaza los botones planos del menú original por tarjetas
/// con ícono, texto y una leve elevación + efecto al presionar.
class ScienceCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ScienceCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<ScienceCard> createState() => _ScienceCardState();
}

class _ScienceCardState extends State<ScienceCard> {
  double _scale = 1.0;

  void _setScale(double v) => setState(() => _scale = v);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setScale(0.96),
      onTapUp: (_) {
        _setScale(1.0);
        widget.onTap();
      },
      onTapCancel: () => _setScale(1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.color, size: 30),
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
