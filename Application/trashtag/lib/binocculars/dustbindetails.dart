import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trashtag/services/waypointservice.dart';
import 'package:trashtag/extensions/extensions.dart';
import 'package:trashtag/models/dustbin.dart';
import 'package:url_launcher/url_launcher.dart';

class DustbinDetails extends StatelessWidget {
  const DustbinDetails({
    super.key,
    required this.dustbin,
    required this.userPosition,
    this.onNavigateClicked,
  });
  final Dustbin dustbin;
  final LatLng userPosition;
  final Function(Dustbin)? onNavigateClicked;

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
          ],
        ),
      ),
    );
  }
}
