import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// "Acerca de Nosotros". El original tenía un botón "Volver" además
/// de la flecha superior y el botón físico Atrás — tal como pide la
/// especificación, aquí se eliminó ese botón duplicado; solo queda la
/// flecha de AppBar (y el botón físico Atrás de Android, que Flutter
/// maneja automáticamente al hacer pop de la ruta).
class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('VirtLab'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const [
            Text(
              'VirtLab es una aplicación educativa desarrollada con el propósito '
              'de mejorar el aprendizaje en Ciencias Naturales, específicamente '
              'en las áreas de química y física.\n\n'
              'La aplicación permite a los estudiantes interactuar con diferentes '
              'experimentos, donde pueden observar procesos, seguir pasos y '
              'responder preguntas basadas en el método científico.\n\n'
              'A diferencia de una clase tradicional, VirtLab no solo presenta '
              'información, sino que busca que el estudiante analice, reflexione '
              'y construya su propio conocimiento a partir de la experiencia.\n\n'
              'Además, incluye actividades que fomentan el pensamiento crítico, '
              'ayudando a comprender conceptos como reacciones químicas, fuerza, '
              'velocidad e inercia de una manera más práctica y dinámica.',
              style: TextStyle(fontSize: 17, color: AppColors.textDark),
            ),
            SizedBox(height: 16),
            Text(
              'Como grupo, quisiéramos fortalecer el aprendizaje en Ciencias '
              'Naturales mediante el uso de experimentos interactivos y '
              'actividades basadas en el análisis y la observación.',
              style: TextStyle(fontSize: 17, color: AppColors.textDark),
            ),
            SizedBox(height: 24),
            Text('Equipo VirtLab',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            SizedBox(height: 10),
            Text('- Engel Cubas.', style: TextStyle(fontSize: 17, color: AppColors.textDark)),
            Text('- Xochilt Brizuela.', style: TextStyle(fontSize: 17, color: AppColors.textDark)),
            Text('- Noham Samuel.', style: TextStyle(fontSize: 17, color: AppColors.textDark)),
            Text('- Magalys Urbina.', style: TextStyle(fontSize: 17, color: AppColors.textDark)),
          ],
        ),
      ),
    );
  }
}
