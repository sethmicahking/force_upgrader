import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:force_upgrader/src/dialog_details.dart';
import 'package:force_upgrader/src/store_urls.dart';
import 'package:force_upgrader/src/strings.dart';
import 'package:force_upgrader/src/upgrade_dialog.dart';

void main() {
  const storeUrls = StoreUrls(androidPackageName: 'android');
  const dialogDetails =
      DialogDetails(allowSkip: true, dialogHeadingText: 'heading');
  onDialogDismissed() => {};

  testWidgets('UpgradeDialog is successfully created', (tester) async {
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: UpgradeDialog(
        storeUrls: storeUrls,
        dialogDetails: dialogDetails,
        onDialogDismissed: onDialogDismissed,
      ),
    ));

    final headingFinder = find.text('heading');
    final bodyFinder = find.text(kUpdateAvailableBody);
    final upgradeButtonFinder = find.byKey(const Key('upgrade-button'));
    final skipButtonFinder = find.byKey(const Key('skip-button'));

    expect(headingFinder, findsOneWidget);
    expect(bodyFinder, findsOneWidget);
    expect(upgradeButtonFinder, findsOneWidget);
    expect(skipButtonFinder, findsOneWidget);
  });
}
