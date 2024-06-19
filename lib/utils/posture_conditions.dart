import 'package:posture_detection_and_correction/models/posture_model.dart';

class PostureConditions {
  final List<Posture> conditions = [
    Posture(
      'Text Neck',
      SensorData(
        Coordination(3.581726, 4.511255, 7.413962),
        Coordination(0.358173, 0.451126, 0.741396),
      ),
      SensorData(
        Coordination(-0.046780, -0.011705, 0.062367),
        Coordination(-0.004678, -0.001170, 0.006237),
      ),
    ),
    Posture(
      'Seated on Couch Looking Down',
      SensorData(
        Coordination(-0.248130, 2.143998, 9.399100),
        Coordination(-0.024813, 0.214400, 0.939910),
      ),
      SensorData(
        Coordination(0.001005, 0.022503, -0.004118),
        Coordination(0.000100, 0.002250, -0.000412),
      ),
    ),
    Posture(
      'Standing with Phone at Eye Level',
      SensorData(
        Coordination(0.108309, 9.219496, 1.141598),
        Coordination(0.010831, 0.921950, 0.114160),
      ),
      SensorData(
        Coordination(
            0.100000, 0.200000, 0.300000), // Replace with actual mean values
        Coordination(0.010000, 0.020000,
            0.030000), // Replace with actual tolerance values
      ),
    ),
    // Add other postures here
  ];

  String checkAccelerometerConditions(Coordination currentPosition) {
    for (var condition in conditions) {
      if (condition.matchesAccelerometer(currentPosition)) {
        return 'Current position matches: ${condition.name}';
      }
    }
    return 'No matching posture found';
  }

  String checkGyroscopeConditions(Coordination currentPosition) {
    for (var condition in conditions) {
      if (condition.matchesGyroscope(currentPosition)) {
        return 'Current position matches: ${condition.name}';
      }
    }
    return 'No matching posture found';
  }
}
