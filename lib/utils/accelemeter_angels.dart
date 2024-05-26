import 'package:posture_detection_and_correction/models/coordinates_model.dart';

class ConditionsAngels {
  Coordination sittingOrStanding = Coordination(0, 9.8, 0);
  Coordination lyingDown = Coordination(0, 0, 9.8);
  Coordination walking = Coordination(0.3, 9.7, 0.5);
  Coordination running = Coordination(0.5, 9.5, 0.7);
  Coordination tilted = Coordination(0, 8.0, 3.0);
  Coordination partiallyInclined = Coordination(0, 7, 4);
  Coordination flatButElevated = Coordination(1, 5, 8);
  Coordination verticalButTilted = Coordination(7, 7, 2);
  Coordination heldUpsideDown = Coordination(0, -9.8, 0);
}




// This is a chatgpt enhancement may be considered in the future
// class AccelerometerConditions {
//   final List<Condition> conditions = [
//     Condition(
//       name: 'Sitting or Standing',
//       expectedPosition: Coordination(0, 8.74, 4.45),
//       tolerance: 0.5,
//     ),
//     Condition(
//       name: 'Lying Down',
//       expectedPosition: Coordination(0, 0, 9.8),
//       tolerance: 0.5,
//     ),
//     // Add more conditions as necessary
//   ];

//   void checkConditions(Coordination currentPosition) {
//     for (var condition in conditions) {
//       if (condition.matches(currentPosition)) {
//         print('Current position matches: ${condition.name}');
//       }
//     }
//   }
// }

// class Condition {
//   String name;
//   Coordination expectedPosition;
//   double tolerance;  // Defines how close the readings must be to the expected values

//   Condition({required this.name, required this.expectedPosition, required this.tolerance});

//   bool matches(Coordination position) {
//     return (position.x - expectedPosition.x).abs() <= tolerance &&
//            (position.y - expectedPosition.y).abs() <= tolerance &&
//            (position.z - expectedPosition.z).abs() <= tolerance;
//   }
// }
