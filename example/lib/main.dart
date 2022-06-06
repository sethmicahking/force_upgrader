import 'package:flutter/material.dart';
import 'package:force_upgrader/force_upgrader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Force Upgrader Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExampleHome(),
    );
  }
}

class ExampleHome extends StatelessWidget {
  const ExampleHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ForceUpgrader(
      getMinimumVersion: () async => '2.0.0',
      allowSkipCallback: () async => true,
      onDialogDismissed: () {
        debugPrint("Skipped");
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Force Upgrader Example'),
        ),
      ),
    );
  }
}
