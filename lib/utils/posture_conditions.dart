import 'package:posture_detection_and_correction/models/posture_model.dart';

class PostureConditions {
  final List<Posture> conditions = [
    Posture(
      'Text Neck',
      SensorData(
        Coordination(3.581725762, 4.511255388, 7.413961584),
        Coordination(0.358172576, 0.451125539, 0.741396158),
      ),
      SensorData(
        Coordination(-0.046780453, -0.011704967, 0.062367371),
        Coordination(-0.004678045, -0.001170497, 0.006236737),
      ),
    ),
    Posture(
      'Seated on Couch Looking Down',
      SensorData(
        Coordination(-0.248130276, 2.143998029, 9.399099603),
        Coordination(-0.024813028, 0.214399803, 0.93990996),
      ),
      SensorData(
        Coordination(0.001004971, 0.022503486, -0.004118414),
        Coordination(0.000100497, 0.002250349, -0.000411841),
      ),
    ),
    Posture(
      'Standing with Phone at Eye Level',
      SensorData(
        Coordination(0.108308896, 9.219496161, 1.141598463),
        Coordination(0.01083089, 0.921949616, 0.114159846),
      ),
      SensorData(
        Coordination(0.074151158, -0.047834689, 0.005960863),
        Coordination(0.007415116, -0.004783469, 0.000596086),
      ),
    ),
    Posture(
      'Close-Up with Slight Head Tilt',
      SensorData(
        Coordination(0.517449841, 9.366395371, 1.632883943),
        Coordination(0.051744984, 0.936639537, 0.163288394),
      ),
      SensorData(
        Coordination(-0.007379646, -0.018256988, 0.003300643),
        Coordination(-0.000737965, -0.001825699, 0.000330064),
      ),
    ),
    Posture(
      'Seated Against Wall with Phone',
      SensorData(
        Coordination(0.443123638, 9.545346992, -0.627328728),
        Coordination(0.044312364, 0.954534699, -0.062732873),
      ),
      SensorData(
        Coordination(-0.002985357, -0.00377357, 0.016769238),
        Coordination(-0.000298536, -0.000377357, 0.001676924),
      ),
    ),
    Posture(
      'Standing with Phone at Chest Level',
      SensorData(
        Coordination(0.376229642, 9.420336179, 1.398041416),
        Coordination(0.037622964, 0.942033618, 0.139804142),
      ),
      SensorData(
        Coordination(-0.007862427, 0.003014916, -0.012788759),
        Coordination(-0.000786243, 0.000301492, -0.001278876),
      ),
    ),
    Posture(
      'Supine Position with Phone Overhead',
      SensorData(
        Coordination(0.274413822, -2.586446519, -9.668605263),
        Coordination(0.027441382, -0.258644652, -0.966860526),
      ),
      SensorData(
        Coordination(0.013044929, 0.006591433, 0.008749167),
        Coordination(0.001304493, 0.000659143, 0.000874917),
      ),
    ),
    Posture(
      'Reclined Relaxation with Phone',
      SensorData(
        Coordination(0.006382941, 4.353606789, -2.72606676),
        Coordination(0.000638294, 0.435360679, -0.272606676),
      ),
      SensorData(
        Coordination(0.258061013, 0.015902203, -0.034878436),
        Coordination(0.025806101, 0.00159022, -0.003487844),
      ),
    ),
    Posture(
      'Prone Position with Elbows Supported',
      SensorData(
        Coordination(0.256851301, 9.366908782, 1.897575175),
        Coordination(0.02568513, 0.936690878, 0.189757517),
      ),
      SensorData(
        Coordination(0.003763718, -0.00073895, 0.000413812),
        Coordination(0.000376372, -7.39e-05, 4.14e-05),
      ),
    ),
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
