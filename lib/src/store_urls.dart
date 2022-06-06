/*
 * Copyright (c) 2022 Seth King. All rights reserved.
 */

/// A convenient collection of marketplace details for the app
///
/// This is a data class that serves to organize details needed to find the app on the various marketplaces or app stores
class StoreUrls {
  /// The optional android package name of the app
  final String? androidPackageName;

  /// The optional iOS AppStore id of the app
  final String? iOSAppStoreId;

  /// The optional macOS AppStore id of the app
  final String? macOSAppStoreId;

  /// The optional Windows Store id of the app
  final String? windowsStoreId;

  /// The optional platform agnostic marketplace or store url
  final String? defaultStoreUrl;

  const StoreUrls(
      {this.androidPackageName,
      this.iOSAppStoreId,
      this.macOSAppStoreId,
      this.windowsStoreId,
      this.defaultStoreUrl});
}
