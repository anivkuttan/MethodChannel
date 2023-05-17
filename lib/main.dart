import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum BluetoothConnection {
  bluetoothON,
  bluetoothOFF,
  bluetoothScanning,
  bluetoothConnecting,
  unKnown
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('com.anikuttan/battery');
  String batteryLevel = "Unknown";
  BluetoothConnection isBluetoothOn = BluetoothConnection.unKnown;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AppBar'),
        ),
        body: Center(
          child: Column(children: [
            Text(
              batteryLevel,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text("Get battery level"),
            )
          ]),
        ));
  }

  Future<void> _getBatteryLevel() async {
    String level = 'level';
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      level = 'Battery level at $result % ';
    } on PlatformException catch (e) {
      level = "Failed to get battery level: ${e.message}";
    }

    setState(() {
      batteryLevel = level;
    });
  }
}
