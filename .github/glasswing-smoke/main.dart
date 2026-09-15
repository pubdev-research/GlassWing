import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const SmokeApp());

class SmokeApp extends StatelessWidget {
  const SmokeApp({super.key});

  static const channel = MethodChannel('glasswing.smoke');

  Future<void> invokeNativeSink() async {
    await channel.invokeMethod<int>('writeLog', <String, Object>{
      'value': 'glasswing-smoke',
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: invokeNativeSink,
            child: const Text('Run GlassWing smoke flow'),
          ),
        ),
      ),
    );
  }
}
