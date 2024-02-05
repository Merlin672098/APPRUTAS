import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:rutasmicros/pages/screens/pasajeros/cons_mapstyle.dart';
import 'package:rutasmicros/pruebaprovider.dart';

class Funciona extends StatefulWidget {
  final String userId;
  final List<LatLng> rutaSeleccionada;

  Funciona(this.userId, this.rutaSeleccionada);

  @override
  _LevitarState createState() => _LevitarState();
}

class _LevitarState extends State<Funciona> {
  GoogleMapController? _controller;
  bool _added = false;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<Position> _requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('La ubi no esta disponible');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos fueron denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('La ubicaion esta permanentementedenegada');
    }

    return await Geolocator.getCurrentPosition();
  }

  _getCurrentLocation() async {
  try {
    Position position = await _requestPermission();

    setState(() {

      markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(
            title: 'Ubicación actual',
            snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
          ),
        ),
      );
    });

  } catch (e) {
    print("Error getting location: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('location')
            .where('linea', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (_added) {
            //mymap(snapshot);
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Set<Marker> markers = Set<Marker>();

          snapshot.data!.docs.forEach((document) {
            bool isParada = document['parada'] ?? false;
            Color markerColor = isParada ? Colors.red : Colors.blue;

            markers.add(
              Marker(
                position: LatLng(
                  (document['latitude'] as num).toDouble(),
                  (document['longitude'] as num).toDouble(),
                ),
                markerId: MarkerId(document.id),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  isParada ? BitmapDescriptor.hueRed : BitmapDescriptor.hueBlue,
                ),
                infoWindow: InfoWindow(
                  title: 'Conductor ${document['name']}',
                  snippet: 'En linea',
                ),
              ),
            );
          });

          if (markers.isNotEmpty) {
            return GoogleMap(
              mapType: MapType.normal,
              markers: markers,
              polylines: polylines,
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
                // Establecer el estilo del mapa
                controller.setMapStyle(themeProvider.getMapStyle());

                setState(() {
                  _controller = controller;
                  _added = true;
                  _drawPolyline();
                  _getCurrentLocation();
                });
              },
            );
          } else {
            return Center(child: Text('No hay marcadores.'));
          }
        },
      ),
    );
  }

  /*Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            snapshot.data!.docs
                    .map((document) => (document['latitude'] as num).toDouble())
                    .reduce((a, b) => a + b) /
                snapshot.data!.docs.length,
            snapshot.data!.docs
                    .map(
                        (document) => (document['longitude'] as num).toDouble())
                    .reduce((a, b) => a + b) /
                snapshot.data!.docs.length,
          ),
          zoom: 14.47,
        ),
      ),
    );
  }*/

  void _drawPolyline() {
    if (widget.rutaSeleccionada.isNotEmpty) {
      List<LatLng> polylineCoordinates = widget.rutaSeleccionada;

      Polyline polyline = Polyline(
        polylineId: PolylineId('rutaSeleccionada'),
        points: polylineCoordinates,
        width: 2,
        color: Colors.blue,
      );

      setState(() {
        polylines.add(polyline);
      });
    }
  }
}
