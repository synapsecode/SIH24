import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static showUserDialog({
    BuildContext? context,
    String? title,
    String? content,
  }) {
    showDialog(
      context: context!,
      builder: (context) {
        return AlertDialog(
          title: Text(title!),
          content: Text(content!),
        );
      },
    );
  }
}
