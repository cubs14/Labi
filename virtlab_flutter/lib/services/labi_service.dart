import 'dart:convert';
import 'package:http/http.dart' as http;

/// Servicio del asistente "Labi": envía las respuestas del estudiante
/// a un modelo de lenguaje (Gemini, igual que en el proyecto original)
/// para darle retroalimentación sobre el experimento.
///
/// ⚠️ IMPORTANTE — SEGURIDAD:
/// El archivo .aia original traía la API key de Gemini escrita
/// directamente en la URL del componente Web (visible para cualquiera
/// que abra el proyecto). NO la reutilicé aquí ni la incluí en este
/// código: esa clave debe considerarse comprometida y hay que
/// regenerarla desde Google AI Studio.
/// Además, una key de Gemini nunca debería viajar embebida en el APK/
/// código del cliente (cualquiera puede extraerla y usarla a tu costa).
/// Lo correcto es llamarla desde un backend propio (por ejemplo, una
/// Cloud Function de Firebase) que guarde la key como secreto de
/// servidor, y que la app llame a esa función en vez de a Gemini
/// directamente. Este servicio ya está escrito para apuntar a ese
/// endpoint propio; solo falta desplegar la función.
class LabiService {
  /// Reemplaza esto por la URL de tu Cloud Function / backend propio.
  static const String _feedbackEndpoint =
      'https://us-central1-labi-2622a.cloudfunctions.net/labiFeedback';

  Future<String> getFeedback({
    required String experimentTitle,
    required List<String> questions,
    required List<String> answers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_feedbackEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'experiment': experimentTitle,
          'questions': questions,
          'answers': answers,
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['feedback'] as String? ?? _fallbackFeedback();
      }
      return _fallbackFeedback();
    } catch (_) {
      return _fallbackFeedback();
    }
  }

  String _fallbackFeedback() =>
      '¡Buen trabajo completando el experimento! 🎉 Sigue observando y '
      'preguntándote el "por qué" de cada reacción — así piensa un '
      'científico.';
}
