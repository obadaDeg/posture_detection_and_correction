import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  late StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  bool _collectingData = true;
  Timer? _timer;

  SensorCubit() : super(SensorDataLoaded()) {
    _startSensorStreams();
    _timer = Timer(const Duration(seconds: 10), () {
      _collectingData = false; 
    });
  }

  void _startSensorStreams() {
    _gyroscopeSubscription =
        SensorsPlatform.instance.gyroscopeEventStream().listen((gyroEvent) {
      if (_collectingData) {
        final currentState = state;
        if (currentState is SensorDataLoaded) {
          final updatedGyroscopeData =
              List<GyroscopeEvent>.from(currentState.gyroscopeData)
                ..add(gyroEvent);
          emit(SensorDataLoaded(
              gyroscopeData: updatedGyroscopeData,
              accelerometerData: currentState.accelerometerData));
        }
      }
    });

    _accelerometerSubscription = SensorsPlatform.instance
        .accelerometerEventStream()
        .listen((accelEvent) {
      if (_collectingData) {
        final currentState = state;
        if (currentState is SensorDataLoaded) {
          final updatedAccelerometerData =
              List<AccelerometerEvent>.from(currentState.accelerometerData)
                ..add(accelEvent);
          emit(SensorDataLoaded(
              gyroscopeData: currentState.gyroscopeData,
              accelerometerData: updatedAccelerometerData));
        }
      }
    });
  }

  void stopCollectingData() {
    _gyroscopeSubscription.cancel();
    _accelerometerSubscription.cancel();
    _timer?.cancel();
    _collectingData = false;
  }

  @override
  Future<void> close() {
    stopCollectingData();
    return super.close();
  }
}
