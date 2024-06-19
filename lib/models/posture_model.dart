class Coordination {
  final double x;
  final double y;
  final double z;

  Coordination(this.x, this.y, this.z);
}

class SensorData {
  final Coordination mean;
  final Coordination tolerance;

  SensorData(this.mean, this.tolerance);

  bool matches(Coordination current) {
    return (current.x - mean.x).abs() <= tolerance.x &&
        (current.y - mean.y).abs() <= tolerance.y &&
        (current.z - mean.z).abs() <= tolerance.z;
  }
}

class Posture {
  final String name;
  final SensorData accelerometerData;
  final SensorData gyroscopeData;

  Posture(this.name, this.accelerometerData, this.gyroscopeData);

  bool matchesAccelerometer(Coordination current) {
    return accelerometerData.matches(current);
  }

  bool matchesGyroscope(Coordination current) {
    return gyroscopeData.matches(current);
  }
}
