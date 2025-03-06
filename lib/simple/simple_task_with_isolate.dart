import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SimpleTaskWithIsolate extends StatefulWidget {
  const SimpleTaskWithIsolate({super.key});

  @override
  State<SimpleTaskWithIsolate> createState() => _SimpleTaskWithIsolateState();
}

class _SimpleTaskWithIsolateState extends State<SimpleTaskWithIsolate> {
  String result = "Press the button";

  static int heavyTask(int limit) {
    int sum = 0;
    for (int i = 0; i < limit; i++) {
      sum += i;
    }
    return sum;
  }

  void startComputation() async {
    setState(() {
      result = "Computing...";
    });
    int sum = await compute(heavyTask, 1000000000);

    setState(() {
      result = "Computation Completed: $sum";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("With Isolate")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(result),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startComputation,
              child: const Text("Start Heavy Task"),
            ),
          ],
        ),
      ),
    );
  }
}