import 'dart:isolate';
import 'package:flutter/material.dart';

class HighTaskWithIsolate extends StatefulWidget {
  const HighTaskWithIsolate({super.key});

  @override
  State<HighTaskWithIsolate> createState() => _HighTaskWithIsolateState();
}

class _HighTaskWithIsolateState extends State<HighTaskWithIsolate> {
  ReceivePort receivePort = ReceivePort();
  SendPort? isolateSendPort;
  String statusMessage = "Press the button to start";

  @override
  void initState() {
    super.initState();
    startIsolate();
  }

  void startIsolate() async {
    await Isolate.spawn(taskComputation, receivePort.sendPort);

    receivePort.listen((message) {
      if (message is SendPort) {
        isolateSendPort = message;
        setState(() {
          statusMessage = "Isolate Ready!";
        });
      } else if (message is String) {
        setState(() {
          statusMessage = "Received String: $message";
        });
      } else if (message is int) {
        setState(() {
          statusMessage = "Received Number: $message";
        });
      } else if (message is Map<String, dynamic>) {
        setState(() {
          statusMessage = "Received Map: ${message.toString()}";
        });
      }
    });
  }

  void sendMessageToIsolate(dynamic message) {
    isolateSendPort?.send(message);
  }

  @override
  void dispose() {
    receivePort.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Single Isolate - Multiple Messages")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(statusMessage, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => sendMessageToIsolate("Hello from Main Thread"),
              child: const Text("Send String"),
            ),
            ElevatedButton(
              onPressed: () => sendMessageToIsolate(42),
              child: const Text("Send Number"),
            ),
            ElevatedButton(
              onPressed: () => sendMessageToIsolate({"task": "compute", "value": 100}),
              child: const Text("Send Map"),
            ),
          ],
        ),
      ),
    );
  }
}

void taskComputation(SendPort mainSendPort) {
  ReceivePort isolateReceivePort = ReceivePort();
  mainSendPort.send(isolateReceivePort.sendPort);

  isolateReceivePort.listen((message) {
    if (message is String) {
      mainSendPort.send("Echo: $message");
    } else if (message is int) {
      mainSendPort.send(message * 2);
    } else if (message is Map<String, dynamic>) {
      mainSendPort.send({"result": "Processed", "input": message});
    }
  });
}