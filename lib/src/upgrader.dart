import 'package:flutter/material.dart';
import 'package:force_upgrader/src/dialog_details.dart';
import 'package:force_upgrader/src/store_urls.dart';
import 'package:force_upgrader/src/upgrade_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

typedef VersionFutureCallBack = Future<String> Function();
typedef AllowSkipFutureCallBack = Future<bool> Function();

const _allowSkipDefault = false;

Future<String> defaultCurrentVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

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

  final Widget child;
  final Widget? upgradeDialog;
  final VersionFutureCallBack getMinimumVersion;
  final VersionFutureCallBack getCurrentVersion;
  final String? androidPackageName;
  final String? iOSAppStoreId;
  final String? macOSAppStoreId;
  final String? windowsStoreId;
  final String? defaultStoreUrl;
  final String? dialogHeadingText;
  final String? dialogBodyText;
  final String? updateButtonText;
  final AllowSkipFutureCallBack? allowSkipCallback;
  final String? skipButtonText;
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
