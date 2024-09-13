import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:trashtag/utils.dart';

class LocationService {
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

  static final loc.Location location = loc.Location();
  static StreamSubscription<loc.LocationData>? locationSubscription;
  static LatLng? currentUserPosition;

  static bool settingPermisisonChangeNeeded = false;

  static void resetLocationService() {
    settingPermisisonChangeNeeded = false;
    currentUserPosition = null;
    locationSubscription?.cancel();
    locationSubscription = null;
  }

  static Future<void> startLocationListener(BuildContext context,
      [int retryCount = 0]) async {
    //TODO: Goes into infinite loop if i try more than twice
    Stream<loc.LocationData>? sub;
    try {
      sub = await LocationService.initalizeLocationServices(
        context: context,
        locationInstance: location,
        onFirstLocationReceived: (lc) {
          if (lc.latitude == null || lc.longitude == null) return;
          currentUserPosition = LatLng(lc.latitude!, lc.longitude!);
          print('CurrentUserPosition Updated!');
        },
      );
      if (sub == null) return;
    } catch (e) {
      print('EXCEPTION => $e');
      ToastContext().init(context);
      Toast.show('Accept Background Location Permission!');
      if (retryCount > 5) {
        Toast.show('Go to Settings & Change Location Permission');
        settingPermisisonChangeNeeded = true;
        return;
      }
      return startLocationListener(context, retryCount++);
    }

    locationSubscription = sub!.listen((loc) {
      print('CurrentUserLocUpdated => $loc');
      currentUserPosition = LatLng(loc.latitude!, loc.longitude!);
    });
  }
}
