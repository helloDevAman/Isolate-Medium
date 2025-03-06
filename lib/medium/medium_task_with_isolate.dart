import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';

class MediumTaskWithIsolate extends StatefulWidget {
  const MediumTaskWithIsolate({super.key});

  @override
  State<MediumTaskWithIsolate> createState() => _MediumTaskWithIsolateState();
}

class _MediumTaskWithIsolateState extends State<MediumTaskWithIsolate> {
  StreamController<double> progressStreamController =
      StreamController<double>();
  String result = "Press the button to start computation";
  bool isComputing = false;
  Isolate? computationIsolate;

  void startComputation() async {
    setState(() {
      isComputing = true;
      result = "Computing...";
    });

    ReceivePort receivePort = ReceivePort();
    computationIsolate = await Isolate.spawn(
      heavyComputation,
      receivePort.sendPort,
    );

    receivePort.listen((message) {
      if (message is double) {
        progressStreamController.add(message);
      } else if (message is int) {
        setState(() {
          result = "Computation Completed: $message";
          isComputing = false;
        });
        progressStreamController.close();
      }
    });
  }

  static void heavyComputation(SendPort sendPort) {
    int sum = 0;
    int totalIterations = 1000000000;
    int progressStep = totalIterations ~/ 100;

    for (int i = 0; i < totalIterations; i++) {
      sum += i;

      if (i % progressStep == 0) {
        sendPort.send((i / totalIterations) * 100);
      }
    }

    sendPort.send(sum);
  }

  @override
  void dispose() {
    progressStreamController.close();
    computationIsolate?.kill(priority: Isolate.immediate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("With Isolate")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(result, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            StreamBuilder<double>(
              stream: progressStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      LinearProgressIndicator(value: snapshot.data ?? 0 / 100),
                      const SizedBox(height: 10),
                      Text("${snapshot.data?.toStringAsFixed(2)}% Completed"),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isComputing ? null : startComputation,
              child: const Text("Start Heavy Task"),
            ),
          ],
        ),
      ),
    );
  }
}
