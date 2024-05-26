part of 'sensor_cubit.dart';


abstract class SensorState {}

class SensorDataLoaded extends SensorState {
  final List<GyroscopeEvent> gyroscopeData;
  final List<AccelerometerEvent> accelerometerData;

  SensorDataLoaded(
      {this.gyroscopeData = const [], this.accelerometerData = const []});
}

class SensorStopped extends SensorState {}
