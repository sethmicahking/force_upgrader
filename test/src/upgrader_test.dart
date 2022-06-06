import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:force_upgrader/force_upgrader.dart';

void main() {
  testWidgets('ForceUpgrader is successfully created', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
          body: ForceUpgrader(
        child: const Text('child-widget'),
        getMinimumVersion: () async => '2.0.0',
        getCurrentVersion: () async => '1.0.0',
        allowSkipCallback: () async => false,
      )),
    ));

    final childTextFinder = find.text('child-widget');

    expect(childTextFinder, findsOneWidget);
  });
}
