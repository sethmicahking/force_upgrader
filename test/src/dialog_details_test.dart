import 'package:flutter_test/flutter_test.dart';
import 'package:force_upgrader/src/dialog_details.dart';

void main() {
  test('Create DialogDetails object', () {
    const details = DialogDetails(
        allowSkip: false,
        dialogBodyText: 'Body Text',
        dialogHeadingText: 'Heading Text',
        updateButtonText: 'Update Button Text',
        skipButtonText: 'Skip Button Text');

    expect(details.allowSkip, false);
    expect(details.dialogBodyText, 'Body Text');
    expect(details.dialogHeadingText, 'Heading Text');
    expect(details.updateButtonText, 'Update Button Text');
    expect(details.skipButtonText, 'Skip Button Text');
  });
}
