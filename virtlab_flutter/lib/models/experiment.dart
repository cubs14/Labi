/// Representa un experimento dentro de una ciencia (Química, Física o
/// Biología). Estructura fiel a las pantallas *_Intro y *_Preguntas del
/// proyecto original de Kodular: materiales, pasos y 3-4 preguntas
/// abiertas que el usuario responde con texto libre.
class Experiment {
  final String id; // ej. 'vinagre'
  final String title;
  final String materials;
  final String steps;
  final List<String> questions;

  const Experiment({
    required this.id,
    required this.title,
    required this.materials,
    required this.steps,
    required this.questions,
  });
}

enum Subject { quimica, fisica, biologia }

extension SubjectX on Subject {
  String get label {
    switch (this) {
      case Subject.quimica:
        return 'Química';
      case Subject.fisica:
        return 'Física';
      case Subject.biologia:
        return 'Biología';
    }
  }

  /// Coincide con el id usado en los logros originales
  /// (logro_quimica_1, logro_fisica_1, logro_biologia_1).
  String get achievementPrefix {
    switch (this) {
      case Subject.quimica:
        return 'quimica';
      case Subject.fisica:
        return 'fisica';
      case Subject.biologia:
        return 'biologia';
    }
  }
}
