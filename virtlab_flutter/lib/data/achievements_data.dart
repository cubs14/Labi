import '../models/achievement.dart';

/// Los 5 logros con tarjeta y texto real en la pantalla "Logros" del
/// proyecto original, más "Sin prisa" (logro_lento): en el original
/// existía un Clock (temporizador) en Q_Preguntas y el tag TinyDB
/// "logro_lento" se leía/escribía en Q_Preguntas.bky y F_Preguntas.bky,
/// pero nunca llegó a tener tarjeta ni condición visible en la
/// pantalla de Logros — es justo el tipo de logro "incompleto" que
/// pediste dejar funcional. Se completó su lógica (tardar más de 3
/// minutos respondiendo un experimento) manteniendo el nombre y la
/// intención que sugiere el propio tag ("lento"); si el equipo tenía
/// otra condición en mente para él, este es el único punto del
/// sistema de logros que quedó inferido en vez de tomado literal del
/// proyecto original.
List<Achievement> buildDefaultAchievements() => [
      Achievement(
        id: 'logro_quimica_1',
        title: 'Primer experimento químico',
        description: 'Completaste tu primer experimento de química',
        iconColorAsset: 'assets/images/logros/color/logrocolor1.png',
        iconGrayAsset: 'assets/images/logros/gris/logrogris1.png',
        xp: 20,
      ),
      Achievement(
        id: 'logro_fisica_1',
        title: 'Primer experimento físico',
        description: 'Completaste tu primer experimento de física',
        iconColorAsset: 'assets/images/logros/color/logrocolor_3.png',
        iconGrayAsset: 'assets/images/logros/gris/logrogris_3.png',
        xp: 20,
      ),
      Achievement(
        id: 'logro_biologia_1',
        title: 'Primer biólogo',
        description: 'Completaste tu primer experimento de biología',
        iconColorAsset: 'assets/images/logros/color/logronuevo.png',
        iconGrayAsset: 'assets/images/logros/gris/logronuevogris.png',
        xp: 20,
      ),
      Achievement(
        id: 'logro_no_idea',
        title: 'No idea',
        description: 'No siempre se tienen todas las respuestas',
        iconColorAsset: 'assets/images/logros/color/logrocolorsecreto_9.png',
        iconGrayAsset: 'assets/images/logros/gris/logrogrissecreto_9.png',
        xp: 5,
      ),
      Achievement(
        id: 'logro_me_rindo',
        title: 'Me rindo',
        description: 'Abandonaste el experimento antes de terminar',
        iconColorAsset: 'assets/images/logros/color/logrocolor_9.png',
        iconGrayAsset: 'assets/images/logros/gris/logrogris_9.png',
        xp: 5,
      ),
      Achievement(
        id: 'logro_lento',
        title: 'Sin prisa',
        description: 'Te tomaste tu tiempo para responder un experimento',
        iconColorAsset: 'assets/images/logros/color/logrocolor_4.png',
        iconGrayAsset: 'assets/images/logros/gris/logrogris_4.png',
        xp: 10,
      ),
    ];
