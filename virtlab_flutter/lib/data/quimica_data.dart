import '../models/experiment.dart';

/// Contenido migrado tal cual desde Q_Intro.bky / Q_Preguntas.bky
/// (proyecto original de Kodular). No se eliminó ni simplificó ningún
/// experimento ni pregunta.
const List<Experiment> quimicaExperiments = [
  Experiment(
    id: 'vinagre',
    title: 'Vinagre + Bicarbonato',
    materials: 'Materiales: Vinagre, Bicarbonato, 1 Vaso.',
    steps:
        'Primero agrega vinagre al vaso, luego añade bicarbonato y finalmente observa la reacción.',
    questions: [
      '¿Qué observaste cuando mezclaste los materiales?',
      '¿Qué crees que causó la reacción?',
      '¿Qué gas piensas que se liberó?',
    ],
  ),
  Experiment(
    id: 'burbujas',
    title: 'Burbujas en Líquido',
    materials: 'Materiales: Agua, Vinagre, Bicarbonato, 1 Vaso.',
    steps:
        'Primero coloca agua en el vaso, agrega un poco de vinagre, luego añade una cucharada de bicarbonato y finalmente observa la reacción.',
    questions: [
      '¿Qué observaste al agregar el bicarbonato a la mezcla?',
      '¿Por qué crees que se formaron burbujas?',
      '¿Qué cambio ocurrió en el líquido después de la reacción?',
    ],
  ),
  Experiment(
    id: 'lava',
    title: 'Lámpara de lava',
    materials:
        'Materiales: Agua, aceite, colorante, Alka-Seltzer, 1 vaso transparente.',
    steps:
        'Primero llena con agua el vaso hasta la mitad, agrega aceite hasta casi llenar el recipiente, añade un poco de colorante, coloca la pastilla en el líquido, agrégale una luz por debajo y observa.',
    questions: [
      '¿Qué sucede al mezclar el aceite y el agua?',
      '¿Por qué el colorante no se mezcla completamente con el aceite?',
      '¿Qué provoca el movimiento de las burbujas dentro del líquido?',
    ],
  ),
  Experiment(
    id: 'limon',
    title: 'Tinta invisible',
    materials: 'Materiales: Jugo de limón, Papel, hisopo y una fuente de calor.',
    steps:
        'Moja un hisopo en jugo de limón, escribe o dibuja en una hoja de papel, déjala secar, aplícale calor con cuidado y observa lo que pasa.',
    questions: [
      '¿Qué ocurre cuando aplicas calor al papel?',
      '¿Qué cambio ocurrió en el papel?',
      '¿Por qué crees que pasó eso?',
    ],
  ),
  Experiment(
    id: 'presion',
    title: 'Colapso por presión',
    materials:
        'Materiales: Lata vacía, Agua, fuente de calor, Recipiente con agua fría, Pinzas.',
    steps:
        'Agrega un poco de agua dentro de la lata, coloca la lata sobre una fuente de calor hasta que empiece a hervir. Con cuidado, voltea la lata rápidamente dentro de un recipiente con agua fría y observa lo que ocurre.',
    questions: [
      '¿Qué ocurrió con la lata al colocarla en agua fría?',
      '¿Qué crees que causó ese cambio en la lata?',
      '¿Por qué el cambio ocurre tan rápido?',
    ],
  ),
  Experiment(
    id: 'serpiente',
    title: 'Serpiente negra',
    materials: 'Materiales: Azúcar, bicarbonato, arena, alcohol, encendedor.',
    steps:
        'Coloca arena formando una pequeña montaña. Mezcla azúcar con bicarbonato. Coloca la mezcla sobre la arena. Añade un poco de alcohol, enciende la mezcla con mucho cuidado y observa lo que pasa.',
    questions: [
      '¿Qué ocurre al encender la mezcla?',
      '¿Por qué la sustancia hace eso?',
      '¿Por qué el cambio ocurre tan rápido?',
    ],
  ),
];
