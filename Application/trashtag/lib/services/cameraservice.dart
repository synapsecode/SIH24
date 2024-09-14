import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  static Future<bool> requestCameraPermission() async {
    if (kIsWeb) {
      return true;
    }
    // For non-web platforms (like Android/iOS)
    var status = await Permission.camera.request();
    bool permStatus = false;
    if (status.isGranted) {
      print('Camera Permission Granted');
      permStatus = true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return permStatus;
  }
}
