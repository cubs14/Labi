import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/experiment.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'labi_chat_screen.dart';

/// Pantalla de preguntas del experimento (Q_Preguntas / F_Preguntas /
/// B_Preguntas). Reglas migradas del original:
/// - No deja continuar si falta alguna respuesta ("Completa todas las
///   respuestas antes de continuar").
/// - Si el usuario responde "no sé" (con o sin tilde) en cualquier
///   pregunta, se desbloquea el logro "No idea".
/// - Si tarda más de 3 minutos en responder desde que abrió esta
///   pantalla, se desbloquea "Sin prisa" (logro_lento) — ver nota en
///   achievements_data.dart sobre por qué esta condición es inferida.
/// - Al finalizar correctamente se desbloquea el logro
///   "Primer experimento de <ciencia>" (solo la primera vez) y se
///   pasa a Labi para recibir retroalimentación ("Experimento
///   completado 🎉").
class ExperimentQuestionsScreen extends StatefulWidget {
  final Subject subject;
  final Experiment experiment;
  final ValueNotifier<bool> completedNotifier;

  const ExperimentQuestionsScreen({
    super.key,
    required this.subject,
    required this.experiment,
    required this.completedNotifier,
  });

  @override
  State<ExperimentQuestionsScreen> createState() => _ExperimentQuestionsScreenState();
}

class _ExperimentQuestionsScreenState extends State<ExperimentQuestionsScreen> {
  late final List<TextEditingController> _controllers;
  late final DateTime _startedAt;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.experiment.questions.length, (_) => TextEditingController());
    _startedAt = DateTime.now();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _finish() async {
    final answers = _controllers.map((c) => c.text.trim()).toList();
    if (answers.any((a) => a.isEmpty)) {
      setState(() => _error = 'Completa todas las respuestas antes de continuar');
      return;
    }
    setState(() => _error = null);

    final state = context.read<AppState>();
    final elapsed = DateTime.now().difference(_startedAt);

    final saidNoSe = answers.any((a) {
      final normalized = a.toLowerCase().replaceAll('é', 'e');
      return normalized.contains('no se');
    });
    if (saidNoSe) {
      await state.unlockAchievement('logro_no_idea');
    }
    if (elapsed > const Duration(minutes: 3)) {
      await state.unlockAchievement('logro_lento');
    }
    await state.unlockAchievement('logro_${widget.subject.achievementPrefix}_1');

    widget.completedNotifier.value = true; // no cuenta como "me rindo"

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LabiChatScreen(
          experiment: widget.experiment,
          answers: answers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exp = widget.experiment;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Responde las siguientes preguntas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (var i = 0; i < exp.questions.length; i++) ...[
              Text(exp.questions[i], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _controllers[i],
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Respuesta', filled: true, fillColor: Colors.white),
              ),
              const SizedBox(height: 18),
            ],
            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
            ],
            ElevatedButton(onPressed: _finish, child: const Text('Finalizar')),
          ],
        ),
      ),
    );
  }
}
