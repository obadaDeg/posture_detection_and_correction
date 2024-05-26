import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:clipboard/clipboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Data App',
      home: SensorDataPage(),
    );
  }
}

class SensorDataPage extends StatefulWidget {
  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  List<GyroscopeEvent> _gyroscopeData = [];
  List<AccelerometerEvent> _accelerometerData = [];
  late StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  bool _collectingData = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startSensorStreams();
    _timer = Timer(const Duration(seconds: 10), () {
      _stopCollectingData();
    });
  }

  void _startSensorStreams() {
    _gyroscopeSubscription =
        SensorsPlatform.instance.gyroscopeEventStream().listen((gyroEvent) {
      if (_collectingData) {
        setState(() {
          _gyroscopeData.add(gyroEvent);
        });
      }
    });

    _accelerometerSubscription = SensorsPlatform.instance
        .accelerometerEventStream()
        .listen((accelEvent) {
      if (_collectingData) {
        setState(() {
          _accelerometerData.add(accelEvent);
        });
      }
    });
  }

  void _stopCollectingData() {
    if (_collectingData) {
      _gyroscopeSubscription.cancel();
      _accelerometerSubscription.cancel();
      _collectingData = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _gyroscopeSubscription.cancel();
    _accelerometerSubscription.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void _copyGyroDataToClipboard() {
    final StringBuffer sb = StringBuffer();
    for (var event in _gyroscopeData) {
      sb.writeln('X: ${event.x}, Y: ${event.y}, Z: ${event.z}');
    }
    FlutterClipboard.copy(sb.toString()).then((value) =>
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gyro data copied to clipboard!'))));
  }

  void _copyAccelDataToClipboard() {
    final StringBuffer sb = StringBuffer();
    for (var event in _accelerometerData) {
      sb.writeln('X: ${event.x}, Y: ${event.y}, Z: ${event.z}');
    }
    FlutterClipboard.copy(sb.toString()).then((value) =>
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Accel data copied to clipboard!'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all),
            onPressed: _copyGyroDataToClipboard,
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copyAccelDataToClipboard,
          )
        ],
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text('Gyroscope Data'),
            children: _gyroscopeData
                .map((data) => ListTile(
                      title: Text('X: ${data.x}, Y: ${data.y}, Z: ${data.z}'),
                    ))
                .toList(),
          ),
          ExpansionTile(
            title: const Text('Accelerometer Data'),
            children: _accelerometerData
                .map((data) => ListTile(
                      title: Text('X: ${data.x}, Y: ${data.y}, Z: ${data.z}'),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
