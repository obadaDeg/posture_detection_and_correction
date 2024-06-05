import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  Timer? _periodicTimer;
  Timer? _readingTimer;
  List<AccelerometerEvent> _accelerometerBuffer = [];
  int _remainingReadingTime = 0;
  int _remainingNextReadTime = 15;

  SensorCubit() : super(SensorDataLoaded()) {
    _startPeriodicReading();
  }

  void _startPeriodicReading() {
    _periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingNextReadTime > 0) {
        _remainingNextReadTime--;
        _emitUpdatedState();
      } else {
        _startReading();
      }
    });
  }

  void _startReading() {
    _accelerometerBuffer.clear();
    _remainingReadingTime = 3;
    _remainingNextReadTime = 15;
    _startSensorStreams();

    _readingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingReadingTime > 0) {
        _remainingReadingTime--;
        _emitUpdatedState();
      } else {
        _readingTimer?.cancel();
        _stopSensorStreams();
        _evaluateMaxReading();
      }
    });
  }

  void _emitUpdatedState() {
    if (state is SensorDataLoaded) {
      final currentState = state as SensorDataLoaded;
      emit(SensorDataLoaded(
        gyroscopeData: currentState.gyroscopeData,
        accelerometerData: currentState.accelerometerData,
        isPositionCorrect: currentState.isPositionCorrect,
        remainingReadingTime: _remainingReadingTime,
        remainingNextReadTime: _remainingNextReadTime,
      ));
    } else {
      emit(SensorDataLoaded(
        remainingReadingTime: _remainingReadingTime,
        remainingNextReadTime: _remainingNextReadTime,
      ));
    }
  }

  void _startSensorStreams() {
    _gyroscopeSubscription =
        SensorsPlatform.instance.gyroscopeEventStream().listen((gyroEvent) {
      if (state is SensorDataLoaded) {
        final currentState = state as SensorDataLoaded;
        final updatedGyroscopeData =
            List<GyroscopeEvent>.from(currentState.gyroscopeData)
              ..add(gyroEvent);
        emit(SensorDataLoaded(
            gyroscopeData: updatedGyroscopeData,
            accelerometerData: currentState.accelerometerData,
            isPositionCorrect: currentState.isPositionCorrect,
            remainingReadingTime: _remainingReadingTime,
            remainingNextReadTime: _remainingNextReadTime));
      }
    });

    _accelerometerSubscription = SensorsPlatform.instance
        .accelerometerEventStream()
        .listen((accelEvent) {
      if (state is SensorDataLoaded) {
        final currentState = state as SensorDataLoaded;
        final updatedAccelerometerData =
            List<AccelerometerEvent>.from(currentState.accelerometerData)
              ..add(accelEvent);

        _accelerometerBuffer.add(accelEvent);

        emit(SensorDataLoaded(
            gyroscopeData: currentState.gyroscopeData,
            accelerometerData: updatedAccelerometerData,
            isPositionCorrect: currentState.isPositionCorrect,
            remainingReadingTime: _remainingReadingTime,
            remainingNextReadTime: _remainingNextReadTime));
      }
    });
  }

  void _stopSensorStreams() {
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription?.cancel();
  }

  void _evaluateMaxReading() {
    double maxX = 0;
    double maxY = 0;
    double maxZ = 0;

    for (var event in _accelerometerBuffer) {
      if (event.x.abs() > maxX) maxX = event.x.abs();
      if (event.y > maxY) maxY = event.y;
      if (event.z > maxZ) maxZ = event.z;
    }

    bool isPositionCorrect = _checkPosition(maxX, maxY, maxZ);
    emit(MaxReadingEvaluated(isPositionCorrect));
  }

  bool _checkPosition(double maxX, double maxY, double maxZ) {
    if (maxY <= 8.5) return false; // Y axis is the highest priority
    if (maxZ > 5.5) return false; // Z axis is the second priority
    if (maxX > 0.5) return false; // X axis is the last priority
    return true;
  }

  void stopCollectingData() {
    _stopSensorStreams();
    _periodicTimer?.cancel();
    _readingTimer?.cancel();
  }

  @override
  Future<void> close() {
    stopCollectingData();
    return super.close();
  }
}
