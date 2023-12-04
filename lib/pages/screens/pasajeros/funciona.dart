import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Funciona extends StatefulWidget {
  final String userId;
  final List<LatLng> rutaSeleccionada;

  Funciona(this.userId, this.rutaSeleccionada);

  @override
  _LevitarState createState() => _LevitarState();
}

class _LevitarState extends State<Funciona> {
  late GoogleMapController _controller;
  bool _added = false;
  Set<Marker> markers = {};
  Set<Polygon> polygons = {};

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

      _addMarker(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
    }
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('location')
            .where('linea', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (_added) {
            mymap(snapshot);
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Set<Marker> markers = Set<Marker>();

          snapshot.data!.docs.forEach((document) {
            markers.add(
              Marker(
                position: LatLng(
                  (document['latitude'] as num).toDouble(),
                  (document['longitude'] as num).toDouble(),
                ),
                markerId: MarkerId(document.id),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueMagenta,
                ),
              ),
            );
          });

          if (markers.isNotEmpty) {
            return GoogleMap(
              mapType: MapType.normal,
              markers: markers,
              polygons: polygons,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  markers
                      .map((marker) => marker.position.latitude)
                      .reduce((a, b) => a + b) /
                      markers.length,
                  markers
                      .map((marker) => marker.position.longitude)
                      .reduce((a, b) => a + b) /
                      markers.length,
                ),
                zoom: 14.47,
              ),
              onMapCreated: (GoogleMapController controller) async {
                setState(() {
                  _controller = controller;
                  _added = true;
                  _drawPolyline();
                });
              },
            );
          } else {
            return Center(child: Text('No markers to display.'));
          }
        },
      ),
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            snapshot.data!.docs
                .map((document) => (document['latitude'] as num).toDouble())
                .reduce((a, b) => a + b) /
                snapshot.data!.docs.length,
            snapshot.data!.docs
                .map((document) => (document['longitude'] as num).toDouble())
                .reduce((a, b) => a + b) /
                snapshot.data!.docs.length,
          ),
          zoom: 14.47,
        ),
      ),
    );
  }

  void _drawPolyline() {
    if (widget.rutaSeleccionada.isNotEmpty) {
      List<LatLng> polylineCoordinates = widget.rutaSeleccionada;

      Polygon polygon = Polygon(
        polygonId: PolygonId('rutaSeleccionada'),
        points: polylineCoordinates,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.3),
      );

      setState(() {
        polygons.add(polygon);
      });
    }
  }
}
