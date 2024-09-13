import 'package:permission_handler/permission_handler.dart';

class CameraService {
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
