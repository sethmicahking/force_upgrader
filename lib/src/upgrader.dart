import 'package:flutter/material.dart';
import 'package:force_upgrader/src/store_urls.dart';
import 'package:force_upgrader/src/upgrade_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

typedef VersionFutureCallBack = Future<String> Function();

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
      this.defaultStoreUrl})
      : super(key: key);

  final Widget child;
  final VersionFutureCallBack getMinimumVersion;
  final VersionFutureCallBack getCurrentVersion;
  final String? androidPackageName;
  final String? iOSAppStoreId;
  final String? macOSAppStoreId;
  final String? windowsStoreId;
  final String? defaultStoreUrl;

  @override
  State<ForceUpgrader> createState() => _ForceUpgraderState();
}

class _ForceUpgraderState extends State<ForceUpgrader> {
  bool fetchedMin = false;
  bool fetchedCurrent = false;

  late String minVersionString;
  late String currentVersionString;

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
  }

  @override
  Widget build(BuildContext context) {
    if (fetchedMin && fetchedCurrent) {
      final minVersion = Version.parse(minVersionString);
      final currentVersion = Version.parse(currentVersionString);
      if (minVersion > currentVersion) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                backgroundColor: Colors.transparent,
                child: UpgradeDialog(
                  storeUrls: StoreUrls(
                    androidPackageName: widget.androidPackageName,
                    iOSAppStoreId: widget.iOSAppStoreId,
                    macOSAppStoreId: widget.macOSAppStoreId,
                    windowsStoreId: widget.windowsStoreId,
                    defaultStoreUrl: widget.defaultStoreUrl,
                  ),
                ),
              ),
            ),
          );
        });
      }
    }
    return widget.child;
  }
}
