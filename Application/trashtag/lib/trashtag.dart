import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:trashtag/backend/TrashTagBackend.dart';
import 'package:trashtag/services/cameraservice.dart';
import 'package:trashtag/utils.dart';

import 'package:trashtag/crossplatform/stub.dart' as crossplatform;

class TrashTagFragment extends StatefulWidget {
  const TrashTagFragment({super.key});

  @override
  State<TrashTagFragment> createState() => _TrashTagFragmentState();
}

class _TrashTagFragmentState extends State<TrashTagFragment> {
  String? productKey;
  String? garbageKey;
  int? userID;
  double? userPoints;
  String mode = 'Product';

  final _trBackend = TrashTagBackend();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/TrashTraceBg.png'),
        colorFilter: ColorFilter.mode(
            Color.fromARGB(255, 221, 240, 210), BlendMode.darken),
        fit: BoxFit.cover,
      )),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (mode == 'loading') ...[
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          ] else ...[
            Image.asset('assets/2.png'),
            SizedBox(height: 50),
            Text(
              'Scan $mode',
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 5),
            Text("TrashTag Points: ${userPoints ?? 'loading'}"),
            const SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: onScanButtonPressed,
                child: const CircleAvatar(
                  backgroundColor: Colors.greenAccent,
                  radius: 70,
                  child: Icon(
                    Icons.qr_code,
                    size: 50,
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ],
      ),
    );
  }

  Future<String?> scanQR() async {
    return crossplatform.scanQR(context);
  }

  onScanButtonPressed() async {
    if (mode == 'Product') {
      //Scan the product
      final pKey = await scanQR();
      if (pKey == null) return;
      print("ProductKey: $pKey");
      setState(() {
        productKey = pKey;
        mode = 'Dustbin';
      });
    } else if (mode == 'Dustbin') {
      final gKey = await scanQR();
      if (gKey == null) return;
      print("GarbageKey: $gKey");
      setState(() {
        garbageKey = gKey;
        mode = 'loading';
      });
      await add2dustbin();
      await initialize();
      setState(() {
        mode = 'Product';
      });
    }
  }

  initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('x-user');

    final uid = await _trBackend.getUserID(username: username!);

    if (uid.result == null) {
      Toast.show('User Not Found');
      return;
    }

    setState(() {
      userID = uid.result;
    });

    await getUserPoints();
  }

  add2dustbin() async {
    ToastContext().init(context);
    if (userID == null) {
      Toast.show('No UserID Found');
      return;
    }
    print("ProductKey: $productKey");
    print("GarbageKey: $garbageKey");
    final res = await _trBackend.add2dustbin(
      userId: userID!,
      qrCodeValue: productKey!,
    );
    Toast.show(res.message);
  }

  getUserPoints() async {
    if (userID == null) {
      Toast.show('Could not Fetch User Points!');
      return;
    }
    final res = await _trBackend.getUserPoints(userID: userID!);
    if (res.result == null) {
      Toast.show(res.message);
      return;
    }
    setState(() {
      userPoints = res.result!;
    });
  }
}
