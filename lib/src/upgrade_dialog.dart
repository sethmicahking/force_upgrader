import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:force_upgrader/src/store_urls.dart';
import 'package:force_upgrader/src/strings.dart';
import 'package:url_launcher/url_launcher.dart';

const _radius = 16.0;
const _angle = 40;

class UpgradeDialog extends StatelessWidget {
  const UpgradeDialog({Key? key, required this.storeUrls}) : super(key: key);

  final StoreUrls storeUrls;

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
                  const Text(kUpdateAvailableTitle,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4.0),
                  const Text(kUpdateAvailableBody),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                      onPressed: () {
                        goToStore(storeUrls);
                      },
                      child: const Text(kDownloadUpdate))
                ],
              ),
            ),
          )),
    );
  }

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
      debugPrint("Could not launch url or url is null");
    }
  }
}
