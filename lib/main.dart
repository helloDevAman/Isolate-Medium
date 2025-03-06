import 'package:flutter/material.dart';

import 'simple/simple_task_without_isolate.dart';

void main() {
  runApp(const App());
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SimpleTaskWithoutIsolate(),
    );
  }
}