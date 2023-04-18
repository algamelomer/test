import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 Bluetooth Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ESP32 Bluetooth Control'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterBluetoothSerial? _bluetooth;
  BluetoothConnection? _connection;

  void initState() {
    super.initState();
    _bluetooth = FlutterBluetoothSerial.instance;
    _bluetooth!.autoConnect('Egy_Tech_2').then((connection) {
      setState(() {
        _connection = connection;
      });
    });
  }

  void dispose() {
    super.dispose();
    _connection?.dispose();
  }

  void _sendCommand(String command) {
    _connection?.output.add(utf8.encode(command));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Motor buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onLongPress: () => _sendCommand('2'),
                  onLongPressEnd: (details) => _sendCommand('0'),
                  child: RaisedButton(child: Text('Forward'), onPressed: null),
                ),
                GestureDetector(
                  onLongPress: () => _sendCommand('4'),
                  onLongPressEnd: (details) => _sendCommand('0'),
                  child: RaisedButton(child: Text('Back'), onPressed: null),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onLongPress: () => _sendCommand('5'),
                  onLongPressEnd: (details) => _sendCommand('0'),
                  child: RaisedButton(child: Text('Left'), onPressed: null),
                ),
                GestureDetector(
                  onLongPress: () => _sendCommand('6'),
                  onLongPressEnd: (details) => _sendCommand('0'),
                  child: RaisedButton(child: Text('Right'), onPressed: null),
                ),
              ],
            ),

            // Servo sliders
            Text('Base Servo'),
            Slider(
              value: 90,
              min: 0,
              max: 180,
              onChanged: (value) {
                setState(() {
                  _sendCommand((2000 + value * 10).toInt().toString());
                });
              },
            ),
            Text('Move Servo'),
            Slider(
              value: 90,
              min: 0,
              max: 180,
              onChanged: (value) {
                setState(() {
                  _sendCommand((1000 + value * 10).toInt().toString());
                });
              },
            ),
            Text('Extend Servo'),
            Slider(
              value: 30,
              min: 0,
              max: 180,
              onChanged: (value) {
                setState(() {
                  _sendCommand((300 + value * 10 / 3).toInt().toString());
                });
              },
            ),
            Text('Grabber Servo'),
            Slider(
              value: 13,
              min: 0,
              max: 180,
              onChanged: (value) {
                setState(() {
                  _sendCommand((400 + value * 10 / 3).toInt().toString());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}