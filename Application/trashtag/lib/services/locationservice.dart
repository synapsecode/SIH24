import 'dart:async';
import 'dart:io' as io; // Adjusted import for web compatibility
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:trashtag/utils.dart';

class LocationService {
  static Future<Stream<loc.LocationData>?> initalizeLocationServices({
    required loc.Location locationInstance,
    required Function(loc.LocationData) onFirstLocationReceived,
    required BuildContext context,
  }) async {
    if (kIsWeb) {
      // Web-specific logic
      final hasPermission = await _checkWebPermissions(context);
      if (hasPermission) {
        final position = await geo.Geolocator.getCurrentPosition();
        loc.LocationData locData = loc.LocationData.fromMap({
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
        onFirstLocationReceived(locData);

        // Return a dummy stream for web
        StreamController<loc.LocationData> locationStreamController =
            StreamController<loc.LocationData>();
        locationStreamController.add(locData);
        return locationStreamController.stream;
      }
      return null;
    } else if (io.Platform.isIOS || io.Platform.isAndroid) {
      // Mobile-specific logic (Android/iOS)
      await requestPermission();
      await locationInstance.changeSettings(
        interval: 300,
        accuracy: loc.LocationAccuracy.high,
      );
      await locationInstance.enableBackgroundMode(enable: true);
      final locdata = await locationInstance.getLocation();
      onFirstLocationReceived(locdata);
      return locationInstance.onLocationChanged;
    }
    return null;
  }

  static Future<bool> requestPermission() async {
    if (kIsWeb) {
      // No need for explicit permissions on web
      return true;
    }
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

  static Future<bool> _checkWebPermissions(BuildContext context) async {
    bool permGranted = await geo.Geolocator.isLocationServiceEnabled();
    if (!permGranted) {
      Utils.showUserDialog(
        context: context,
        content: 'We need location permission to run the application!',
        title: 'Permission not given',
      );
    }
    return permGranted;
  }

  static final loc.Location location = loc.Location();
  static StreamSubscription<loc.LocationData>? locationSubscription;
  static LatLng? currentUserPosition = LatLng(12.9728512, 77.6077312);

  static bool settingPermisisonChangeNeeded = false;

  static void resetLocationService() {
    settingPermisisonChangeNeeded = false;
    currentUserPosition = null;
    locationSubscription?.cancel();
    locationSubscription = null;
  }

  static Future<void> startLocationListener(BuildContext context,
      [int retryCount = 0]) async {
    // Prevents infinite loop if retry exceeds limit
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
