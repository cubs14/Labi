import 'package:flutter/material.dart';
import '../data/biologia_data.dart';
import '../data/fisica_data.dart';
import '../data/quimica_data.dart';
import '../models/experiment.dart';
import '../theme/app_theme.dart';
import 'experiment_intro_screen.dart';

/// Lista de experimentos disponibles para una ciencia (reemplaza a las
/// pantallas Quimica / Fisica / Biologia del proyecto original, que
/// solo servían para elegir uno de sus experimentos).
class SubjectIntroScreen extends StatelessWidget {
  final Subject subject;
  const SubjectIntroScreen({super.key, required this.subject});

  List<Experiment> get _experiments {
    switch (subject) {
      case Subject.quimica:
        return quimicaExperiments;
      case Subject.fisica:
        return fisicaExperiments;
      case Subject.biologia:
        return biologiaExperiments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(subject.label),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _experiments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final exp = _experiments[index];
          return Material(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ExperimentIntroScreen(subject: subject, experiment: exp),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.15),
                      child: const Icon(Icons.science_outlined, color: AppColors.primaryDark),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(exp.title,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.primaryDark),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
