import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trashtag/models/dustbin.dart';
import 'package:url_launcher/url_launcher.dart';

class WaypointService {
  static Future<bool> openGoogleMaps(
      LatLng userPosition, Dustbin dustbin) async {
    const rawUrl = 'https://www.google.com/maps/dir/?api=1';
    final destination = '${dustbin.latitude},${dustbin.longitude}';
    final origin = '${userPosition.latitude},${userPosition.longitude}';

    //TODO: Try to use Intents here to directly open mobile app
    String googleMapsURL = [
      rawUrl,
      'origin=$origin',
      'destination=$destination',
      'travelmode=walking',
    ].join('&');

    final uri = Uri.tryParse(googleMapsURL);
    if (uri == null) return false;
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch Google Maps';
      }
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  static Future startNavigation(
      String mode, LatLng userPosition, Dustbin dustbin) async {
    if (mode == 'gmaps') {
      return await openGoogleMaps(userPosition, dustbin);
    } else {
      routePolygons = {};
      routeCoords = [];
      return await getInAppRoute(
          userPosition, LatLng(dustbin.latitude, dustbin.longitude));
    }
  }

  static endInAppNavigation() {
    routePolygons = {};
    routeCoords = [];
  }

  static Set<Polyline> routePolygons = {};
  static List<LatLng> routeCoords = [];

  static Future<void> getInAppRoute(LatLng start, LatLng end) async {
    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/walking/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> routes = data['routes'];
        if (routes.isNotEmpty) {
          final List<dynamic> coordinates =
              routes[0]['geometry']['coordinates'];
          routeCoords = coordinates
              .map((coord) => LatLng(coord[1], coord[0])) // Inverting to LatLng
              .toList();
          _setPolyline();
        }
      } else {
        print('Error fetching route: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static void _setPolyline() {
    Polyline polyline = Polyline(
      polylineId: PolylineId('walking_route'),
      color: Colors.blue,
      width: 5,
      points: routeCoords,
    );
    routePolygons.add(polyline);
  }
}
