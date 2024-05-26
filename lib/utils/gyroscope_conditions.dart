
import 'package:posture_detection_and_correction/models/coordinates_model.dart';

class GyroscopeConditions {
  static Coordination standStill = Coordination(0, 0, 0);
  static Coordination walking = Coordination(0.3, 9.7, 0.5);
  static Coordination running = Coordination(0.5, 5.2, 0.7);
}
