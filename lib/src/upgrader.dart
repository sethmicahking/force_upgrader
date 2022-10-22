/*
 * Copyright (c) 2022 Seth King. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:force_upgrader/src/dialog_details.dart';
import 'package:force_upgrader/src/store_urls.dart';
import 'package:force_upgrader/src/upgrade_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

/// Signature of callbacks that have no arguments and return a Future String
typedef VersionFutureCallBack = Future<String> Function();

/// Signature of callbacks that have no arguments and return a Future bool
typedef AllowSkipFutureCallBack = Future<bool> Function();

/// Default value for allowing skips
const _allowSkipDefault = false;

/// Fetches the current package version string of the app
Future<String> defaultCurrentVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

/// An upgrader widget that goes high in your widget tree and shows an upgrade dialog when appropriate
class ForceUpgrader extends StatefulWidget {
  const ForceUpgrader(
      {Key? key,
      required this.child,
      required this.getMinimumVersion,
      this.getCurrentVersion = defaultCurrentVersion,
      this.androidPackageName,
      this.iOSAppStoreId,
      this.macOSAppStoreId,
      this.windowsStoreId,
      this.defaultStoreUrl,
      this.upgradeDialog,
      this.dialogHeadingText,
      this.dialogBodyText,
      this.updateButtonText,
      this.allowSkipCallback,
      this.skipButtonText,
      this.onDialogDismissed})
      : super(key: key);

  /// The child widget to return under [Upgrader]
  final Widget child;

  /// An optional custom upgrade dialog
  final Widget? upgradeDialog;

  /// The future callback to get the minimum version string
  final VersionFutureCallBack getMinimumVersion;

  /// The future callback to call to get the current version string
  final VersionFutureCallBack getCurrentVersion;

  /// The optional Android package name of the flutter app
  final String? androidPackageName;

  /// The optional iOS AppStore Id of the flutter app
  final String? iOSAppStoreId;

  /// The optional macOSAppStoreId of the flutter app
  final String? macOSAppStoreId;

  /// The optional windowsStoreId of the the flutter app
  final String? windowsStoreId;

  /// The optional upgrade url of the flutter app
  final String? defaultStoreUrl;

  /// Custom optional heading text for the upgrade dialog
  final String? dialogHeadingText;

  /// Custom optional body text for the upgrade dialog
  final String? dialogBodyText;

  /// Custom optional text for the upgrade dialog's update button
  final String? updateButtonText;

  /// The future callback to call to determine if skipping is allowed
  final AllowSkipFutureCallBack? allowSkipCallback;

  /// Custom optional text for the upgrade dialog's skip button
  final String? skipButtonText;

  /// The optional callback to call when upgrade dialog's skip button is pressed
  final VoidCallback? onDialogDismissed;

  @override
  State<ForceUpgrader> createState() => _ForceUpgraderState();
}

class _ForceUpgraderState extends State<ForceUpgrader> {
  bool fetchedMin = false;
  bool fetchedCurrent = false;
  bool fetchedAllowSkip = false;
  bool showingDialog = false;

  late String minVersionString;
  late String currentVersionString;
  late bool allowSkip;

  @override
  void initState() {
    super.initState();
    widget.getCurrentVersion().then((current) {
      setState(() {
        fetchedCurrent = true;
        currentVersionString = current;
      });
    });
    widget.getMinimumVersion().then((min) {
      setState(() {
        fetchedMin = true;
        minVersionString = min;
      });
    });

    if (widget.allowSkipCallback == null) {
      setState(() {
        fetchedAllowSkip = true;
        allowSkip = _allowSkipDefault;
      });
    } else {
      widget.allowSkipCallback!().then((skip) {
        setState(() {
          fetchedAllowSkip = true;
          allowSkip = skip;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fetchedMin && fetchedCurrent && fetchedAllowSkip) {
      final minVersion = Version.parse(minVersionString);
      final currentVersion = Version.parse(currentVersionString);
      if (minVersion > currentVersion && !showingDialog) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                backgroundColor: Colors.transparent,
                child: widget.upgradeDialog ??
                    UpgradeDialog(
                      storeUrls: StoreUrls(
                        androidPackageName: widget.androidPackageName,
                        iOSAppStoreId: widget.iOSAppStoreId,
                        macOSAppStoreId: widget.macOSAppStoreId,
                        windowsStoreId: widget.windowsStoreId,
                        defaultStoreUrl: widget.defaultStoreUrl,
                      ),
                      dialogDetails: DialogDetails(
                          dialogHeadingText: widget.dialogHeadingText,
                          dialogBodyText: widget.dialogBodyText,
                          updateButtonText: widget.updateButtonText,
                          allowSkip: allowSkip,
                          skipButtonText: widget.skipButtonText),
                      onDialogDismissed: () {
                        showingDialog = false;
                        if (widget.onDialogDismissed != null) {
                          widget.onDialogDismissed!();
                        }
                      },
                    ),
              ),
            ),
          );
          showingDialog = true;
        });
      }
    }
    return widget.child;
  }
}
