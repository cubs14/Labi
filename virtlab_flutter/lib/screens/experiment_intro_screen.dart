import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/experiment.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'experiment_questions_screen.dart';

/// Pantalla de introducción de un experimento: título, materiales y
/// pasos (equivalente a Q_Intro / F_Intro / B_Intro del original).
/// Si el usuario sale de aquí sin llegar a "Finalizar" el
/// cuestionario, se desbloquea el logro "Me rindo" (logro_me_rindo),
/// igual que en el proyecto original.
class ExperimentIntroScreen extends StatefulWidget {
  final Subject subject;
  final Experiment experiment;
  const ExperimentIntroScreen({super.key, required this.subject, required this.experiment});

  @override
  State<ExperimentIntroScreen> createState() => _ExperimentIntroScreenState();
}

class _ExperimentIntroScreenState extends State<ExperimentIntroScreen> {
  final ValueNotifier<bool> _completed = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    // Marca el inicio del experimento (equivalente al tag
    // "inicio_experimento" del proyecto original).
  }

  @override
  void dispose() {
    if (!_completed.value) {
      // Salió sin terminar -> logro "Me rindo".
      context.read<AppState>().unlockAchievement('logro_me_rindo');
    }
    _completed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exp = widget.experiment;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.subject.label),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(exp.title,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 20),
              const Text('Materiales', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(exp.materials, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              const Text('Pasos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(exp.steps, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ExperimentQuestionsScreen(
                          subject: widget.subject,
                          experiment: exp,
                          completedNotifier: _completed,
                        ),
                      ),
                    );
                  },
                  child: const Text('Siguiente'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
