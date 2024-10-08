import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trashtag/services/waypointservice.dart';
import 'package:trashtag/extensions/extensions.dart';
import 'package:trashtag/models/dustbin.dart';
import 'package:url_launcher/url_launcher.dart';

class DustbinDetails extends StatelessWidget {
  DustbinDetails({
    super.key,
    required this.dustbin,
    required this.userPosition,
    this.onNavigateClicked,
  });
  final Dustbin dustbin;
  final LatLng userPosition;
  final Function(Dustbin)? onNavigateClicked;

  final Uri _url = Uri.parse(
      'https://ce7e-2401-4900-900d-af0c-b519-93f1-4c53-ff7f.ngrok-free.app/ecoperks/vendor/login');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    double distance = Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      dustbin.latitude,
      dustbin.longitude,
    );

    return Container(
      color: const Color.fromARGB(255, 40, 40, 40),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Community Tagged Dustbin').color(Colors.white38),
            Text(dustbin.name)
                .color(Colors.white)
                .weight(FontWeight.bold)
                .size(40),
            SizedBox(
              height: 10,
            ),
            Text('Type : ${dustbin.type}').color(Colors.amber),
            Text('Distance : ${(distance / 1000).toStringAsFixed(2)} km')
                .color(Colors.white),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                WaypointService.openGoogleMaps(userPosition, dustbin);
              },
              icon: const Icon(Icons.navigation),
              label: const Text('Navigate with GMaps'),
            ).limitSize(300),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                if (onNavigateClicked != null) {
                  onNavigateClicked!(dustbin);
                }
              },
              icon: const Icon(Icons.navigation),
              label: const Text('Navigate in-App'),
            ).limitSize(300),
            SizedBox(
              height: 15,
            ),
            Visibility(
              visible: dustbin.type != 'QRBIN',
              child: ElevatedButton.icon(
                onPressed: _launchUrl,
                icon: Icon(Icons.qr_code_2_outlined),
                label: Text("Request QR"),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
