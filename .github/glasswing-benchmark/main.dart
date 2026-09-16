import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String pluginName = String.fromEnvironment('GW_PLUGIN');
const String channelName = String.fromEnvironment('GW_CHANNEL');
const String methodName = String.fromEnvironment('GW_METHOD');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PluginHostApp());
}

class PluginHostApp extends StatefulWidget {
  const PluginHostApp({Key? key}) : super(key: key);

  @override
  State<PluginHostApp> createState() => _PluginHostAppState();
}

class _PluginHostAppState extends State<PluginHostApp> {
  String status = 'not invoked';

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(invokePlugin);
  }

  Future<void> invokePlugin() async {
    const channel = MethodChannel(channelName);
    const payload = <String, Object>{
      'plainText': 'benchmark-sensitive-plaintext',
      'key': '12345678912345670648654658281111',
      'iv': '101112345678',
      'filePath': '/sdcard/Download/benchmark-input.apk',
      'pageNumber': 1,
      'value': 'benchmark-user-controlled-value',
    };

    try {
      final result = await channel.invokeMethod<Object?>(methodName, payload);
      if (mounted) {
        setState(() => status = 'completed: $result');
      }
    } on PlatformException catch (error) {
      if (mounted) {
        setState(() => status = 'platform error: ${error.code}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text('$pluginName: $status')),
      ),
    );
  }
}
