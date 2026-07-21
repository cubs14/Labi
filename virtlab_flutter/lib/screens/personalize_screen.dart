import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/colorblind.dart';
import 'menu_screen.dart';

/// "Personaliza tu experiencia": color de fondo, color de botones,
/// color de texto, tamaño de texto y daltonismo, todo con vista
/// previa inmediata, tal como pide la especificación.
class PersonalizeScreen extends StatefulWidget {
  final bool firstTime;
  const PersonalizeScreen({super.key, required this.firstTime});

  @override
  State<PersonalizeScreen> createState() => _PersonalizeScreenState();
}

class _PersonalizeScreenState extends State<PersonalizeScreen> {
  static const _bgOptions = <String, Color>{
    'Verde': Color(0xFF9BFAB0),
    'Azul': Color(0xFFA9D6FF),
    'Morado': Color(0xFFD9C2FF),
    'Negro': Color(0xFF1C1C1C),
    'Blanco': Color(0xFFFFFFFF),
    'Gris': Color(0xFFD9D9D9),
    'Celeste': Color(0xFFBFEFFF),
    'Naranja': Color(0xFFFFD9B3),
  };

  static const _buttonOptions = <String, Color>{
    'Verde': Color(0xFF2A8C4A),
    'Azul': Color(0xFF2E6FE0),
    'Morado': Color(0xFF7B3FE0),
    'Negro': Color(0xFF1C1C1C),
    'Gris': Color(0xFF6B6B6B),
    'Celeste': Color(0xFF2FA5C9),
    'Naranja': Color(0xFFE0842A),
  };

  static const _textOptions = <String, Color>{
    'Negro': Colors.black,
    'Blanco': Colors.white,
    'Azul oscuro': Color(0xFF10306B),
    'Verde oscuro': Color(0xFF0F3D1F),
    'Gris oscuro': Color(0xFF3A3A3A),
  };

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      body: Column(
        children: [
          // ---- Vista previa en tiempo real ----
          Container(
            width: double.infinity,
            color: state.backgroundColor,
            padding: const EdgeInsets.all(20),
            child: ColorBlindFilter(
              mode: state.colorBlindMode,
              child: Column(
                children: [
                  Text(
                    'Vista previa',
                    style: TextStyle(
                      fontSize: 22 * state.textScale,
                      fontWeight: FontWeight.bold,
                      color: state.textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: state.buttonColor),
                    child: Text('Botón de ejemplo', style: TextStyle(fontSize: 16 * state.textScale)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('Personaliza tu experiencia',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('Configura VirtLab para adaptarla a tu estilo y necesidades.',
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 20),
                _sectionTitle('Color del fondo'),
                _colorRow(_bgOptions, state.backgroundColor, (c) {
                  state.backgroundColor = c;
                  state.notifyListeners();
                }),
                _sectionTitle('Color de los botones'),
                _colorRow(_buttonOptions, state.buttonColor, (c) {
                  state.buttonColor = c;
                  state.notifyListeners();
                }),
                _sectionTitle('Color del texto'),
                _colorRow(_textOptions, state.textColor, (c) {
                  state.textColor = c;
                  state.notifyListeners();
                }),
                _sectionTitle('Tamaño del texto'),
                Slider(
                  value: state.textScale,
                  min: 0.8,
                  max: 1.6,
                  divisions: 8,
                  label: state.textScale < 1.0
                      ? 'Pequeño'
                      : (state.textScale <= 1.2 ? 'Mediano' : 'Grande'),
                  onChanged: (v) {
                    state.textScale = v;
                    state.notifyListeners();
                  },
                ),
                _sectionTitle('Daltonismo'),
                const Text(
                  'Selecciona el tipo de visión que más se parezca a la tuya.\n'
                  'VirtLab adaptará automáticamente los colores para mejorar la experiencia.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ColorBlindMode.values.map((mode) {
                    final selected = state.colorBlindMode == mode;
                    return ChoiceChip(
                      label: Text(mode.label),
                      selected: selected,
                      onSelected: (_) {
                        state.colorBlindMode = mode;
                        state.notifyListeners();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () async {
                    await state.savePersonalization();
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MenuScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text('Guardar preferencias y continuar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );

  Widget _colorRow(Map<String, Color> options, Color current, void Function(Color) onPick) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.entries.map((entry) {
        final selected = entry.value.value == current.value;
        return GestureDetector(
          onTap: () => onPick(entry.value),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: entry.value,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.primaryDark : Colors.black26,
                width: selected ? 3 : 1,
              ),
            ),
            child: selected
                ? Icon(Icons.check,
                    color: entry.value.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
