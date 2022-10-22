// Created by Seth Micah King on 7/16/22.
// Copyright (c) 2022 | All rights reserved.

class UnsupportedPlatform implements Exception {
  @override
  String toString() {
    return 'The current platform is not supported. Ensure you\'re running on Android, iOS, MacOS or Windows';
  }
}
