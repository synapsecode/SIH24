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

  static Future<Stream<loc.LocationData>?> initalizeLocationServices({
    required loc.Location locationInstance,
    required Function(loc.LocationData) onFirstLocationReceived,
    required BuildContext context,
  }) async {
    if (Platform.isIOS) {
      await requestPermission();
      await locationInstance.changeSettings(
        interval: 300,
        accuracy: loc.LocationAccuracy.high,
      );
      await locationInstance.enableBackgroundMode(enable: true);
      final locdata = await locationInstance.getLocation();
      onFirstLocationReceived(locdata);
      return locationInstance.onLocationChanged;
    } else {
      //Android
      final status = await requestPermission();
      if (status) {
        await locationInstance.enableBackgroundMode(enable: true);
        final locdata = await locationInstance.getLocation();
        onFirstLocationReceived(locdata);
        return locationInstance.onLocationChanged;
      } else {
        print('PERMISSION DENIED');
        // ignore: use_build_context_synchronously
        Utils.showUserDialog(
          context: context,
          content: 'We need location function to run the application!',
          title: 'Permission not given',
        );
      }
    }
    return null;
  }

  static Future<bool> requestPermission() async {
    var status = await Permission.location.request();
    bool permStatus = false;
    if (status.isGranted) {
      print('Location Permission Granted');
      permStatus = true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return permStatus;
  }

  static Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    bool permStatus = false;
    if (status.isGranted) {
      print('Location Permission Granted');
      permStatus = true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return permStatus;
  }
}
