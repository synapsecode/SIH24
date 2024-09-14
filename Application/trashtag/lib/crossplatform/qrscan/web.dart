import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_qrcode_scanner/flutter_web_qrcode_scanner.dart';
import 'package:toast/toast.dart';
import 'package:trashtag/services/cameraservice.dart';

Future<String?> scanQR(BuildContext context) async {
  ToastContext().init(context);

  final s = await CameraService.requestCameraPermission();
  if (!s) {
    Toast.show('Camera Permission not given');
    return null;
  }
  final Completer<String?> c = Completer<String?>();

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => WebQRScanner(
        completer: c,
      ),
    ),
  );

  return c.future;
}

class WebQRScanner extends StatefulWidget {
  final Completer<String?> completer;
  const WebQRScanner({super.key, required this.completer});

  @override
  State<WebQRScanner> createState() => _WebQRScannerState();
}

class _WebQRScannerState extends State<WebQRScanner> {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    start();
  }

  start() {
    _controller = CameraController(autoPlay: true);
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return SizedBox();
    return Scaffold(
      backgroundColor: Colors.black,
      body: FlutterWebQrcodeScanner(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        controller: _controller,
        cameraDirection: CameraDirection.back,
        stopOnFirstResult: false,
        onGetResult: (String data) {
          if (data.isEmpty) return;
          if (widget.completer.isCompleted) return;
          _controller?.dispose();
          _controller = null;
          setState(() {});
          Future.delayed(Duration(milliseconds: 200), () {
            widget.completer.complete(data);
            Navigator.pop(context);
          });
        },
      ),
    );
  }
}
