import 'dart:io';

import 'package:force_upgrader/src/store_urls.dart';
import 'package:url_launcher/url_launcher.dart';

/// Serves as a namespace for all marketplace url functionality
class LauncherHelper {
  /// Url prefix for the Google PlayStore
  static const kPlayStorePrefix =
      'https://play.google.com/store/apps/details?id=';

  /// Url prefix for the Apple AppStore on iOS
  static const kIOSAppStorePrefix = 'https://apps.apple.com/app/id';

  /// Url prefix for the Apple AppStore on MacOS
  static const kMacOSAppStorePrefix =
      'https://apps.apple.com/ru/app/g-app-launcher/id';

  /// Url prefix for the Windows Store
  static const kWindowsStorePrefix = 'https://apps.microsoft.com/store/detail/';

  /// Get marketplace uri from [suffixOrUrl]
  static Uri getUpgradeUri(
      {required String suffixOrUrl, bool ignorePlatform = false}) {
    late Uri uri;

    if (Platform.isAndroid && !ignorePlatform) {
      uri = Uri.parse('$kPlayStorePrefix$suffixOrUrl');
    } else if (Platform.isIOS && !ignorePlatform) {
      uri = Uri.parse('$kIOSAppStorePrefix$suffixOrUrl');
    } else if (Platform.isMacOS && !ignorePlatform) {
      uri = Uri.parse('$kMacOSAppStorePrefix$suffixOrUrl');
    } else if (Platform.isWindows && !ignorePlatform) {
      uri = Uri.parse('$kWindowsStorePrefix$suffixOrUrl');
    } else {
      uri = Uri.parse(suffixOrUrl);
    }
    return uri;
  }

  /// Launches the appropriate appstore url of the current app and platform
  static Uri? getStoreUri({required StoreUrls urls}) {
    Uri? url;
    if (Platform.isAndroid && urls.androidPackageName != null) {
      url = Uri.parse('$kPlayStorePrefix${urls.androidPackageName}');
    } else if (Platform.isIOS && urls.iOSAppStoreId != null) {
      url = Uri.parse('$kIOSAppStorePrefix${urls.iOSAppStoreId}');
    } else if (Platform.isMacOS && urls.macOSAppStoreId != null) {
      url = Uri.parse('$kMacOSAppStorePrefix${urls.macOSAppStoreId}');
    } else if (Platform.isWindows && urls.windowsStoreId != null) {
      url = Uri.parse('$kWindowsStorePrefix${urls.windowsStoreId}');
    } else if (urls.defaultStoreUrl != null) {
      url = Uri.parse(urls.defaultStoreUrl!);
    }

    return url;
  }

  /// Attempts to launch app's marketplace page from [uri]
  static Future goToStore({required Uri uri}) async {
    if (!await launchUrl(uri)) {
      throw 'Store details or url not found';
    }
  }
}
