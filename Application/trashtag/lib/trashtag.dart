import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:trashtag/utils.dart';

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
            Color.fromARGB(255, 192, 212, 197), BlendMode.screen),
        fit: BoxFit.cover,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (mode == 'loading') ...[
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          ] else ...[
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
                  radius: 70,
                  child: Icon(
                    Icons.qr_code,
                    size: 50,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<String?> scanQR() async {
    ToastContext().init(context);
    final s = await Utils.requestCameraPermission();
    if (!s) {
      Toast.show('Camera Permission not given');
      return null;
    }
    final res = await scanner.scan();
    return res;
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
    //TODO: Implement this once Backend routes are ready
  }

  add2dustbin() async {
    //TODO: Implement this once Backend Routes are ready
  }

  getUserPoints() async {
    //TODO: Implement this once Backend Routes are ready
  }
}
