/*
 * Copyright (c) 2022 Seth King. All rights reserved.
 */

/// A convenient collection upgrade dialog details
///
/// This is a data class that serves to organize details needed show and customize the upgrade dialog
class DialogDetails {
  const DialogDetails(
      {required this.allowSkip,
      this.dialogHeadingText,
      this.dialogBodyText,
      this.updateButtonText,
      this.skipButtonText});

  /// The flag to enable skipping the upgrade dialog
  final bool allowSkip;

  /// The optional string to customize the default dialog's heading text
  final String? dialogHeadingText;

  /// The optional string to customize the default dialog's body text
  final String? dialogBodyText;

  /// The optional string to customize the default dialog's update button text
  final String? updateButtonText;

  /// The optional string to customize the default dialog's skip button text
  final String? skipButtonText;
}
