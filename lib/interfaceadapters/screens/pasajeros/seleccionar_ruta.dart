import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<LatLng> points = [
    LatLng(-21.510214875367648, -64.73416460474809),
    LatLng(-21.512310995450953, -64.73568809946215),
    LatLng(-21.51408768317933, -64.737018475144487),
    LatLng(-21.51882505845082, -64.74044374513599),
    LatLng(-21.519394566622083, -64.73962750511157),
  ];

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(-21.51408768317933, -64.737018475144487),
        zoom: 14.0,
      ),
      markers: <Marker>[
        Marker(
          markerId: MarkerId('PolygonMarker'),
          position: LatLng(-21.51408768317933, -64.737018475144487),
          infoWindow: InfoWindow(title: 'Centro del polígono'),
        ),
      ].toSet(),
      polylines: <Polyline>[
        Polyline(
          polylineId: PolylineId('Polyline'),
          points: points,
          color: Colors.blue,
          width: 2,
        ),
      ].toSet(),
    );
  }
}