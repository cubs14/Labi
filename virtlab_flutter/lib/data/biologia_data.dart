import '../models/experiment.dart';

/// Contenido migrado tal cual desde B_Intro.bky / B_Preguntas.bky.
const List<Experiment> biologiaExperiments = [
  Experiment(
    id: 'pulmon',
    title: 'Pulmón casero',
    materials:
        'Materiales: 1 botella plástica, 2 globos, 1 pajilla, cinta adhesiva, tijeras.',
    steps:
        'Corta la botella por la mitad. Coloca un globo dentro de la botella conectado a la pajilla. Cubre la parte inferior con otro globo estirado. Tira del globo inferior. Observa cómo el globo interior se infla simulando un pulmón.',
    questions: [
      '¿Qué crees que representa el globo dentro de la botella?',
      '¿Qué sucede al tirar del globo inferior?',
      '¿Qué sistema del cuerpo se representa?',
    ],
  ),
  Experiment(
    id: 'frijol',
    title: 'Germinación de frijol',
    materials: 'Materiales: 1 frijol, algodón, agua, vaso transparente.',
    steps:
        'Coloca algodón dentro del vaso. Humedece el algodón con agua. Pon el frijol sobre el algodón. Deja el vaso cerca de la luz. Observa su crecimiento durante varios días.',
    questions: [
      '¿Qué necesita el frijol para crecer?',
      '¿Dónde debe colocarse el vaso?',
      '¿Qué observamos después de unos días?',
    ],
  ),
  Experiment(
    id: 'transpiracion',
    title: 'Transpiración de plantas',
    materials: 'Materiales: Hojas de una planta, bolsa transparente, cinta.',
    steps:
        'Coloca una bolsa alrededor de una hoja o rama. Ciérrala con cinta. Déjala bajo la luz durante unas horas. Observa las gotas de agua dentro de la bolsa. Comprueba cómo la planta libera agua.',
    questions: [
      '¿Qué aparece dentro de la bolsa?',
      '¿Qué demuestra este experimento?',
      '¿Qué libera la planta?',
    ],
  ),
  Experiment(
    id: 'adn',
    title: 'ADN de tomate',
    materials: 'Materiales: tomate, jabón líquido, sal, agua, alcohol, vaso.',
    steps:
        'Tritura el tomate en un vaso. Mezcla agua, jabón y sal. Agrega la mezcla al tomate. Añade lentamente alcohol. Observa las fibras blancas del ADN.',
    questions: [
      '¿Qué parte blanca aparece en el experimento?',
      '¿Qué fruta o verdura usamos?',
      '¿Qué sustancia ayuda a separar el ADN?',
    ],
  ),
];
