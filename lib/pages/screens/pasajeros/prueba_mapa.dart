import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late Position currentPosition;


  List<LatLng> points = [
    const LatLng(-21.514163, -64.737140),
    const LatLng(-21.521457, -64.742304),
    const LatLng(-21.523080, -64.740487),
    const LatLng(-21.527162, -64.739527),
    const LatLng(-21.532713, -64.740717),
    const LatLng(-21.536801, -64.736810),
    const LatLng(-21.538562, -64.733722),
    const LatLng(-21.520704, -64.727075),
    const LatLng(-21.519459, -64.728301),
    const LatLng(-21.517445, -64.729935),
    const LatLng(-21.514163, -64.737139),
  ];

  List<LatLng> newPolygonPoints = [
  const LatLng(-21.514163, -64.737140),
    const LatLng(-21.521457, -64.742304),
    const LatLng(-21.523080, -64.740487),
    const LatLng(-21.527162, -64.739527),
    const LatLng(-21.532713, -64.740717),
    const LatLng(-21.536801, -64.736810),
];


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = position;
      });

      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(currentPosition.latitude, currentPosition.longitude),
        ),
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void showNewPolygon() {
  setState(() {
    points = newPolygonPoints;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12.0,
        ),
        polygons: {
          Polygon(
            polygonId: const PolygonId('polyId'),
            points: points,
            strokeWidth: 2,
            strokeColor: Colors.blue,
            fillColor: Colors.blue.withOpacity(0.3),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNewPolygon();
        },
        child: Icon(Icons.add),
      ),
    );
    
  }
}