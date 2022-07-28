import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  StreamSubscription? connection;
  String connectionType = "Unknown";
  bool isConnected = false;
  bool isOnline = false;

  @override
  void initState() {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenever connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isOnline = false;
          isConnected = false;
          connectionType = "Offline";
        });
      } else {
        setState(() {
          isConnected = true;
        });
        switch (result) {
          case ConnectivityResult.bluetooth:
            setState(() {
              connectionType = "Bluetooth";
            });
            break;
          case ConnectivityResult.ethernet:
            setState(() {
              connectionType = "Ethernet";
            });
            break;
          case ConnectivityResult.mobile:
            setState(() {
              connectionType = "Mobile";
            });
            break;
          case ConnectivityResult.wifi:
            setState(() {
              connectionType = "Wi-Fi";
            });
            break;
          default:
            // Unreachable
            connectionType = "Unknown";
        }
        checkInternet();
      }
    });
    super.initState();
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        setState(() {
          isOnline = true;
        });
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
      isOnline = false;
    }
  }

  @override
  void dispose() {
    connection!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Internet Connection"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(children: [
          Container(
            width: double.infinity,
            height: 100.0,
            alignment: Alignment.center,
            color: isConnected ? Colors.green : Colors.red,
            child: Text(
              'Connection Type: $connectionType',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            height: 100.0,
            alignment: Alignment.center,
            color: isOnline ? Colors.green : Colors.red,
            child: Text(
              'Internet Access: ${isOnline ? "available" : "Not Available"}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                overflow: TextOverflow.fade,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
