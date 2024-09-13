import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trashtag/models/dustbin.dart';
import 'package:url_launcher/url_launcher.dart';

class DustbinDetails extends StatelessWidget {
  const DustbinDetails({
    super.key,
    required this.dustbin,
    required this.userPosition,
  });
  final Dustbin dustbin;
  final LatLng userPosition;

  @override
  Widget build(BuildContext context) {
    double distance = Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      dustbin.latitude,
      dustbin.longitude,
    );

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Name : ${dustbin.name}'),
          SizedBox(
            height: 10,
          ),
          Text('Type : ${dustbin.type}'),
          SizedBox(
            height: 10,
          ),
          Text('Distance : ${(distance / 1000).toStringAsFixed(2)} km'),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
            onPressed: () async {
              const rawUrl = 'https://www.google.com/maps/dir/?api=1';
              final destination = '${dustbin.latitude},${dustbin.longitude}';
              final origin =
                  '${userPosition.latitude},${userPosition.longitude}';

              //TODO: Try to use Intents here to directly open mobile app
              String googleMapsURL = [
                rawUrl,
                'origin=$origin',
                'destination=$destination',
                'travelmode=walking',
              ].join('&');

              final uri = Uri.tryParse(googleMapsURL);
              if (uri == null) return;
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                throw 'Could not launch Google Maps';
              }
            },
            icon: const Icon(Icons.navigation),
            label: const Text('Navigate'),
          )
        ],
      ),
    );
  }
}
