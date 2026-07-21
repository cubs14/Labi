import '../models/experiment.dart';

/// Contenido migrado tal cual desde F_Intro.bky / F_Preguntas.bky.
const List<Experiment> fisicaExperiments = [
  Experiment(
    id: 'velosidad',
    title: 'Velocidad de un objeto',
    materials: 'Materiales: Una cinta métrica, una pelota y un cronómetro.',
    steps:
        'Primero estira la cinta métrica a 10 metros, vuelve al inicio y coloca la pelota, dale un pequeño impulso y mide el tiempo que tarda en terminar.',
    questions: [
      '¿Cuánto tiempo tardó en recorrer la distancia?',
      '¿La velocidad fue constante?',
      '¿Qué factores afectan la velocidad?',
      'Si una pelota recorre 10 metros en 2 segundos, ¿cuál es su velocidad?',
    ],
  ),
  Experiment(
    id: 'fuerza',
    title: 'Fuerza y movimiento',
    materials: 'Materiales: Libro y una mesa o base alta.',
    steps:
        'Primero coloca el libro sobre la base, empuja suavemente el libro, empuja un poco más fuerte y observa sus distintos movimientos.',
    questions: [
      '¿Qué ocurre al aplicar más fuerza?',
      '¿Cómo cambia el movimiento del objeto?',
      '¿Qué relación hay entre fuerza y movimiento?',
      'Si aumentas la fuerza aplicada a un objeto, ¿qué ocurre con su aceleración?',
    ],
  ),
  Experiment(
    id: 'tiempo',
    title: 'Medición del tiempo',
    materials: 'Materiales: Cronómetro y una pelota.',
    steps:
        'Primero lanza la pelota hacia arriba. Luego mide el tiempo que dura en caer. Repite 2 o más veces y compara los resultados.',
    questions: [
      '¿Cuánto tiempo tarda en caer la pelota?',
      '¿El tiempo fue siempre igual?',
      '¿Qué factores pueden afectar el tiempo?',
      'Si un objeto tarda más tiempo en caer, ¿qué pudo haber cambiado?',
    ],
  ),
  Experiment(
    id: 'inercia',
    title: 'Inercia de los objetos',
    materials: 'Materiales: Una tarjeta, una moneda de cualquier tamaño y un vaso.',
    steps:
        'Pon la tarjeta sobre el vaso, pon la moneda sobre la tarjeta, golpea rápidamente la tarjeta hacia cualquier dirección y observa lo que pasa con la moneda.',
    questions: [
      '¿Qué ocurrió con la moneda al mover la tarjeta?',
      '¿Por qué crees que pasó eso con la moneda?',
      '¿Por qué la moneda no se mueve junto con la tarjeta al ser golpeada?',
      '¿Qué pasaría con la moneda si la tarjeta se moviera lentamente en lugar de rápido?',
    ],
  ),
];
