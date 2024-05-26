import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posture_detection_and_correction/view_models/sensor_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Data App',
      home: BlocProvider<SensorCubit>(
        create: (_) => SensorCubit(),
        child: const SensorDataPage(),
      ),
    );
  }
}

class SensorDataPage extends StatelessWidget {
  const SensorDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Data'),
        toolbarHeight: 100.0,
        actions: [
          Column(
            children: [
              TextButton(
                child: const Text('Copy Gyroscope Data'),
                onPressed: () {
                  final state = context.read<SensorCubit>().state;
                  if (state is SensorDataLoaded) {
                    final StringBuffer sb = StringBuffer();
                    for (var event in state.gyroscopeData) {
                      sb.writeln('X: ${event.x}, Y: ${event.y}, Z: ${event.z}');
                    }
                    Clipboard.setData(ClipboardData(text: sb.toString()))
                        .then((_) => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Gyroscope data copied to clipboard!'))))
                        .catchError((e) => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                                content: Text(
                                    'Failed to copy gyroscope data: $e'))));
                  }
                },
              ),
              TextButton(
                child: const Text('Copy Accelerometer Data'),
                onPressed: () {
                  final state = context.read<SensorCubit>().state;
                  if (state is SensorDataLoaded) {
                    final StringBuffer sb = StringBuffer();
                    for (var event in state.accelerometerData) {
                      sb.writeln('X: ${event.x}, Y: ${event.y}, Z: ${event.z}');
                    }
                    Clipboard.setData(ClipboardData(text: sb.toString()))
                        .then((_) => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Accelerometer data copied to clipboard!'))))
                        .catchError((e) => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                                content: Text(
                                    'Failed to copy accelerometer data: $e'))));
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<SensorCubit, SensorState>(
        builder: (context, state) {
          if (state is SensorDataLoaded) {
            return ListView(
              children: [
                ExpansionTile(
                  title: const Text('Gyroscope Data'),
                  children: state.gyroscopeData
                      .map((data) => ListTile(
                            title: Text(
                                'X: ${data.x}, Y: ${data.y}, Z: ${data.z}'),
                          ))
                      .toList(),
                ),
                ExpansionTile(
                  title: const Text('Accelerometer Data'),
                  children: state.accelerometerData
                      .map((data) => ListTile(
                            title: Text(
                                'X: ${data.x}, Y: ${data.y}, Z: ${data.z}'),
                          ))
                      .toList(),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
