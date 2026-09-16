import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String pluginName = String.fromEnvironment('GW_PLUGIN');
const String channelName = String.fromEnvironment('GW_CHANNEL');
const String eventChannelName = String.fromEnvironment('GW_EVENT_CHANNEL');
const String methodName = String.fromEnvironment('GW_METHOD');
const String payloadKind = String.fromEnvironment('GW_PAYLOAD_KIND');

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
    const mapPayload = <String, Object>{
      'plainText': 'benchmark-sensitive-plaintext',
      'key': '12345678912345670648654658281111',
      'iv': '101112345678',
      'filePath': '/sdcard/Download/benchmark-input.apk',
      'path': '/sdcard/Download/benchmark-input.pdf',
      'paths': <String>['/sdcard/Download/benchmark-input.pdf'],
      'outputDirPath': '/sdcard/Download/benchmark-output.pdf',
      'pageNumber': 1,
      'posId': 'benchmark-position',
      'logo': 'benchmark_logo',
      'timeout': 3.5,
      'appName': 'benchmark-app',
      'expFeat': false,
      'value': 'benchmark-user-controlled-value',
    };
    final Object payload = payloadKind == 'notification_action'
        ? <Object>['benchmark-notification-id', 0]
        : mapPayload;

    try {
      if (eventChannelName.isNotEmpty) {
        const EventChannel(eventChannelName).receiveBroadcastStream(
          'benchmark-event-arguments',
        ).listen((_) {});
      }
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
