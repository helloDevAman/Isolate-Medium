import 'dart:async';

import 'package:flutter/material.dart';

class MediumTaskWithoutIsolate extends StatefulWidget {
  const MediumTaskWithoutIsolate({super.key});

  @override
  State<MediumTaskWithoutIsolate> createState() => _MediumTaskWithoutIsolateState();
}

class _MediumTaskWithoutIsolateState extends State<MediumTaskWithoutIsolate> {
  StreamController<double> progressStreamController = StreamController<double>();
  String result = "Press the button to start computation";
  bool isComputing = false;

  Future<void> startComputation() async {
    setState(() {
      isComputing = true;
      result = "Computing...";
    });

    if (progressStreamController.isClosed) {
      progressStreamController = StreamController<double>();
    }

    int sum = 0;
    int totalIterations = 1000000000;
    int progressStep = totalIterations ~/ 100;

    for (int i = 0; i < totalIterations; i++) {
      sum += i;

      if (i % progressStep == 0) {
        progressStreamController.add((i / totalIterations) * 100);
        await Future.delayed(const Duration(milliseconds: 1));
      }
    }

    setState(() {
      result = "Computation Completed: $sum";
      isComputing = false;
    });

    progressStreamController.close();
  }

  @override
  void dispose() {
    progressStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Without Isolate")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(result, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            StreamBuilder<double>(
              stream: progressStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Column(
                    children: [
                      LinearProgressIndicator(value: snapshot.data! / 100),
                      const SizedBox(height: 10),
                      Text("${snapshot.data!.toStringAsFixed(2)}% Completed"),
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