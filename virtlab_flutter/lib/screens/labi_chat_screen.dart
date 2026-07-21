import 'package:flutter/material.dart';
import '../models/experiment.dart';
import '../services/labi_service.dart';
import '../theme/app_theme.dart';
import 'menu_screen.dart';

/// Pantalla "labi_chat": muestra a Labi (la mascota/asistente de
/// VirtLab) dando retroalimentación sobre las respuestas del
/// estudiante, tal como en el proyecto original (que llamaba a
/// Gemini). Ver services/labi_service.dart para la nota de seguridad
/// sobre la API key.
class LabiChatScreen extends StatefulWidget {
  final Experiment experiment;
  final List<String> answers;
  const LabiChatScreen({super.key, required this.experiment, required this.answers});

  @override
  State<LabiChatScreen> createState() => _LabiChatScreenState();
}

class _LabiChatScreenState extends State<LabiChatScreen> {
  final _labi = LabiService();
  String? _feedback;

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  Future<void> _loadFeedback() async {
    final result = await _labi.getFeedback(
      experimentTitle: widget.experiment.title,
      questions: widget.experiment.questions,
      answers: widget.answers,
    );
    if (mounted) setState(() => _feedback = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text('LABI', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 8),
              const Text('Experimento completado 🎉',
                  style: TextStyle(fontSize: 18, color: AppColors.textDark)),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset('assets/images/labi.jpg', height: 140, width: 140, fit: BoxFit.cover),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: _feedback == null
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : SingleChildScrollView(
                          child: Text(_feedback!, style: const TextStyle(fontSize: 16)),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MenuScreen()),
                    (route) => false,
                  ),
                  child: const Text('Finalizar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
