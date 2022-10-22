/*
 * Copyright (c) 2022 Seth King. All rights reserved.
 */

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:force_upgrader/src/dialog_details.dart';
import 'package:force_upgrader/src/dialogs/android_dialog.dart';
import 'package:force_upgrader/src/dialogs/ios_dialog.dart';
import 'package:force_upgrader/src/dialogs/macos_dialog.dart';
import 'package:force_upgrader/src/dialogs/windows_dialog.dart';
import 'package:force_upgrader/src/store_urls.dart';

import 'error/unsupported_platform.dart';

/// Default upgrade dialog that shows when upgrade conditions are met
class UpgradeDialog extends StatelessWidget {
  const UpgradeDialog(
      {Key? key,
      required this.storeUrls,
      required this.dialogDetails,
      required this.onDialogDismissed})
      : super(key: key);

  /// The store urls of the app
  final StoreUrls storeUrls;

  /// The details of the upgrade dialog
  final DialogDetails dialogDetails;

  /// The callback to call when the upgrade dialog's skip button is pressed
  final VoidCallback onDialogDismissed;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      throw UnsupportedPlatform();
    }

    if (Platform.isAndroid) {
      return AndroidDialog(
          storeUrls: storeUrls,
          dialogDetails: dialogDetails,
          onDialogDismissed: onDialogDismissed);
    } else if (Platform.isIOS) {
      return IOSDialog(
          storeUrls: storeUrls,
          dialogDetails: dialogDetails,
          onDialogDismissed: onDialogDismissed);
    } else if (Platform.isMacOS) {
      return MacOSDialog(
          storeUrls: storeUrls,
          dialogDetails: dialogDetails,
          onDialogDismissed: onDialogDismissed);
    } else if (Platform.isWindows) {
      return WindowsDialog(
          storeUrls: storeUrls,
          dialogDetails: dialogDetails,
          onDialogDismissed: onDialogDismissed);
    } else {
      throw UnsupportedPlatform();
    }
  }
}
