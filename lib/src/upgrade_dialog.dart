/*
 * Copyright (c) 2022 Seth King. All rights reserved.
 */

import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:force_upgrader/src/dialog_details.dart';
import 'package:force_upgrader/src/store_urls.dart';
import 'package:force_upgrader/src/strings.dart';
import 'package:url_launcher/url_launcher.dart';

/// THe radius of the upgrade dialog
const _radius = 16.0;

/// The rotational angle of the upgrade dialog
const _angle = 40;

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
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inverseSurface,
          border: Border.all(
              color: Theme.of(context).colorScheme.surface, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(_radius))),
      child: Transform.rotate(
          angle: -math.pi / _angle,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(_radius))),
            child: Transform.rotate(
              angle: math.pi / _angle,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(dialogDetails.dialogHeadingText ?? kUpdateAvailableTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4.0),
                  Text(dialogDetails.dialogBodyText ?? kUpdateAvailableBody),
                  const SizedBox(height: 16.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            goToStore(storeUrls);
                          },
                          child: Text(dialogDetails.updateButtonText ??
                              kDownloadUpdate)),
                      if (dialogDetails.allowSkip)
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onDialogDismissed();
                            },
                            child: Text(
                                dialogDetails.skipButtonText ?? kSkipVersion))
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  /// Launches the appropriate appstore url of the current app and platform
  Future goToStore(StoreUrls urls) async {
    Uri? url;

    if (Platform.isAndroid && urls.androidPackageName != null) {
      url = Uri.parse(
          'https://play.google.com/store/apps/details?id=${urls.androidPackageName}');
    } else if (Platform.isIOS && urls.iOSAppStoreId != null) {
      url = Uri.parse('https://apps.apple.com/app/id${urls.iOSAppStoreId}');
    } else if (Platform.isMacOS && urls.macOSAppStoreId != null) {
      url = Uri.parse(
          'https://apps.apple.com/ru/app/g-app-launcher/id${urls.macOSAppStoreId}');
    } else if (Platform.isWindows && urls.windowsStoreId != null) {
      url = Uri.parse(
          'https://apps.microsoft.com/store/detail/${urls.windowsStoreId}');
    } else if (urls.defaultStoreUrl != null) {}

    if (url == null || !await launchUrl(url)) {
      throw 'Store details or url not found';
    }
  }
}
