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
  String errorMessage = '';
  static const platform = MethodChannel('com.anikuttan/battery');
  static const platformBluetooth =
      MethodChannel('com.anikuttan/bluetooth_On_OFF');
  String bluetoothOnMethodName = 'getBluetoothStatus';

  String batteryLevel = "Unknown";
  BluetoothConnection bluetoothStatus = BluetoothConnection.unKnown;

  @override
  void initState() {
    super.initState();
    _checkBluetooth();
  }

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
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: _getBatteryLevel,
            child: const Text("Get battery level"),
          ),
          ListTile(
            title: const Text("Hello"),
            trailing: ElevatedButton(
              onPressed: () {},
              child: bluetoothStatus == BluetoothConnection.bluetoothON
                  ? const Text('ON')
                  : const Text('OFF'),
            ),
          )
        ]),
      ),
    );
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

  Future<void> _checkBluetooth() async {
    bool currentState = false;
    try {
      final bool status =
          await platformBluetooth.invokeMethod(bluetoothOnMethodName);
      currentState = status;
    } on PlatformException catch (e) {
      errorMessage = '${e.message}';
      SnackBar snack = SnackBar(content: Text(errorMessage));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
    setState(
      () {
        currentState
            ? bluetoothStatus = BluetoothConnection.bluetoothON
            : bluetoothStatus = BluetoothConnection.bluetoothOFF;
        print("Anikuttan $currentState");
      },
    );
  }
}
