// Created by Seth Micah King on 7/15/22.
// Copyright (c) 2022 | All rights reserved.

import 'package:flutter/material.dart';
import 'package:force_upgrader/src/dialog_details.dart';
import 'package:force_upgrader/src/dialogs/force_dialog.dart';
import 'package:force_upgrader/src/store_urls.dart';

class WindowsDialog extends StatelessWidget implements ForceDialog {
  @override
  final StoreUrls storeUrls;
  @override
  final DialogDetails dialogDetails;
  @override
  final VoidCallback onDialogDismissed;

  const WindowsDialog(
      {Key? key,
      required this.storeUrls,
      required this.dialogDetails,
      required this.onDialogDismissed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
