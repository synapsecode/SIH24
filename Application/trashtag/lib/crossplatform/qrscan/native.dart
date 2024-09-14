import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:trashtag/services/cameraservice.dart';
import 'package:qrscan/qrscan.dart' as scanner;

Future<String?> scanQR(BuildContext context) async {
  ToastContext().init(context);
  final s = await CameraService.requestCameraPermission();
  if (!s) {
    Toast.show('Camera Permission not given');
    return null;
  }
  final res = await scanner.scan();
  return res;
}
