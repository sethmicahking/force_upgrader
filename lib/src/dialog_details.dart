class DialogDetails {
  const DialogDetails(
      {required this.allowSkip,
      this.dialogHeadingText,
      this.dialogBodyText,
      this.updateButtonText,
      this.skipButtonText});

  final bool allowSkip;
  final String? dialogHeadingText;
  final String? dialogBodyText;
  final String? updateButtonText;
  final String? skipButtonText;
}
