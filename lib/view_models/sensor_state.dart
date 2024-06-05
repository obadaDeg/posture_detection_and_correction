part of 'sensor_cubit.dart';

abstract class SensorState {}

class SensorDataLoaded extends SensorState {
  final List<GyroscopeEvent> gyroscopeData;
  final List<AccelerometerEvent> accelerometerData;
  final bool isPositionCorrect;
  final int remainingReadingTime;
  final int remainingNextReadTime;

  SensorDataLoaded({
    this.gyroscopeData = const [],
    this.accelerometerData = const [],
    this.isPositionCorrect = true,
    this.remainingReadingTime = 0,
    this.remainingNextReadTime = 0,
  });
}

class SensorStopped extends SensorState {}

class MaxReadingEvaluated extends SensorState {
  final bool isPositionCorrect;

  MaxReadingEvaluated(this.isPositionCorrect);
}
