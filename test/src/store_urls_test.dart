import 'package:flutter_test/flutter_test.dart';
import 'package:force_upgrader/src/store_urls.dart';

void main() {
  test('Create StoreUrls object', () {
    const urls = StoreUrls(
        androidPackageName: 'android',
        iOSAppStoreId: 'iOS',
        windowsStoreId: 'windows',
        macOSAppStoreId: 'macOS',
        defaultStoreUrl: 'url');

    expect(urls.androidPackageName, 'android');
    expect(urls.iOSAppStoreId, 'iOS');
    expect(urls.windowsStoreId, 'windows');
    expect(urls.macOSAppStoreId, 'macOS');
    expect(urls.defaultStoreUrl, 'url');
  });
}
