import 'package:flutter/material.dart';

class SimpleTaskWithoutIsolate extends StatefulWidget {
  const SimpleTaskWithoutIsolate({super.key});

  @override
  State<SimpleTaskWithoutIsolate> createState() => _SimpleTaskWithoutIsolateState();
}

class _SimpleTaskWithoutIsolateState extends State<SimpleTaskWithoutIsolate> {
  String result = "Press the button";

  void heavyComputation() {
    int sum = 0;
    for (int i = 0; i < 1000000000; i++) {
      sum += i;
    }
    setState(() {
      result = "Computation Completed: $sum";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Without Isolate")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(result),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: heavyComputation,
              child: const Text("Start Heavy Task"),
            ),
          ],
        ),
      ),
    );
  }
}