import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/experiment.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/colorblind.dart';
import '../widgets/achievement_unlock_dialog.dart';
import '../widgets/science_card.dart';
import 'acerca_de_screen.dart';
import 'logros_screen.dart';
import 'profile_screen.dart';
import 'subject_intro_screen.dart';

/// Menú principal de VirtLab — el mismo menú de siempre (Química,
/// Física, Biología, Logros, Acerca de Nosotros) pero rediseñado:
/// cuadrícula de tarjetas con ícono, degradado y entrada animada, más
/// el ícono de Perfil en la esquina superior izquierda. Respeta la
/// personalización elegida por el usuario (colores, tamaño de texto,
/// daltonismo) y escucha los desbloqueos de logros para mostrar la
/// notificación en cualquier momento que ocurran.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _items = [
    _MenuItem(Subject.quimica, Icons.science_outlined, AppColors.primary),
    _MenuItem(Subject.fisica, Icons.bolt_outlined, Color(0xFF2E6FE0)),
    _MenuItem(Subject.biologia, Icons.eco_outlined, Color(0xFF3AA65A)),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _fadeFor(int index) {
    final start = 0.1 * index;
    final end = (start + 0.5).clamp(0.0, 1.0);
    return CurvedAnimation(parent: _controller, curve: Interval(start, end, curve: Curves.easeOut));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return AchievementUnlockListener(
      child: PopScope(
        // En el menú principal, el botón físico Atrás cierra la app
        // (no debe regresar a Login/Registro), tal como pide la
        // especificación del botón físico de Android.
        canPop: true,
        child: Scaffold(
          body: ColorBlindFilter(
            mode: state.colorBlindMode,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [state.backgroundColor, state.backgroundColor.withOpacity(0.7)],
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _ProfileButton(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
                      child: Column(
                        children: [
                          Image.asset('assets/images/virtlab.png', height: 96),
                          const SizedBox(height: 8),
                          Text(
                            'VirtLab',
                            style: TextStyle(
                              fontSize: 34 * state.textScale,
                              fontWeight: FontWeight.w800,
                              color: state.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Descubrir, experimentar y comprender.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15 * state.textScale,
                              fontStyle: FontStyle.italic,
                              color: state.textColor,
                            ),
                          ),
                          const SizedBox(height: 28),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Selecciona una ciencia',
                              style: TextStyle(
                                fontSize: 18 * state.textScale,
                                fontWeight: FontWeight.bold,
                                color: state.textColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _items.length + 1, // + Logros
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1.05,
                            ),
                            itemBuilder: (context, index) {
                              if (index == _items.length) {
                                return FadeTransition(
                                  opacity: _fadeFor(index),
                                  child: ScienceCard(
                                    title: 'Logros',
                                    icon: Icons.emoji_events_outlined,
                                    color: AppColors.accentGold,
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const LogrosScreen()),
                                    ),
                                  ),
                                );
                              }
                              final item = _items[index];
                              return FadeTransition(
                                opacity: _fadeFor(index),
                                child: ScienceCard(
                                  title: item.subject.label,
                                  icon: item.icon,
                                  color: item.color,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => SubjectIntroScreen(subject: item.subject),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          FadeTransition(
                            opacity: _fadeFor(_items.length + 1),
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AcercaDeScreen()),
                              ),
                              icon: Icon(Icons.info_outline, color: state.textColor),
                              label: Text(
                                'Acerca de Nosotros',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: state.textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                side: const BorderSide(color: AppColors.primaryDark, width: 1.4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final Subject subject;
  final IconData icon;
  final Color color;
  const _MenuItem(this.subject, this.icon, this.color);
}

class _ProfileButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ProfileButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.85),
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.person_outline, color: AppColors.primaryDark, size: 26),
        ),
      ),
    );
  }
}
