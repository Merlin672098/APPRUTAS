import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  final List<LatLng> rutaSeleccionada;

  MapScreen({required this.rutaSeleccionada});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late Position currentPosition;
  Set<Marker> markers = {};




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

      _addMarker(currentPosition.latitude, currentPosition.longitude);
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void showNewPolygon() {
    setState(() {});
  }

  void _addMarker(double lat, double lng) {
    Marker marker = Marker(
      markerId: const MarkerId('ubicacionActual'),
      position: LatLng(lat, lng),
      infoWindow: const InfoWindow(title: 'Mi ubi'),
      icon: BitmapDescriptor.defaultMarker,
    );

    setState(() {
      markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RUTAS DE MICROS'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(-21.53318473012909, -64.73134628111355),
          zoom: 12.0,
        ),
        markers: markers,
        polygons: {
            Polygon(
              polygonId: const PolygonId('polyId'),
              points: widget.rutaSeleccionada,
              strokeWidth: 2,
              strokeColor: Colors.blue,
              fillColor: Colors.transparent,
          ),
        },
      ),
    );
  }
}
