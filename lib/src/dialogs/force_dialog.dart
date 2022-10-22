// Created by Seth Micah King on 7/15/22.
// Copyright (c) 2022 | All rights reserved.

import 'package:flutter/material.dart';
import 'package:force_upgrader/src/dialog_details.dart';
import 'package:force_upgrader/src/store_urls.dart';

abstract class ForceDialog {
  final StoreUrls storeUrls;
  final DialogDetails dialogDetails;
  final VoidCallback onDialogDismissed;

  const ForceDialog(
      {Key? key,
      required this.storeUrls,
      required this.dialogDetails,
      required this.onDialogDismissed});
}
