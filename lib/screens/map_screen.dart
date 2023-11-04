import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

// ignore: constant_identifier_names
const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoibWVybGluNjcyMDk4IiwiYSI6ImNsb2l1cGt5cDFoZzYycW8zcWg4MndwdHIifQ.aqR3PMqNLZJ9XVHST39X3Q';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

List<LatLng> points = [
  LatLng(-21.514163, -64.737140),
  LatLng(-21.521457, -64.742304),
  LatLng(-21.523080, -64.740487),
  LatLng(-21.527162, -64.739527),
  LatLng(-21.532713, -64.740717),
  LatLng(-21.536801, -64.736810),
  LatLng(-21.538562, -64.733722),
  LatLng(-21.520704, -64.727075),
  LatLng(-21.519459, -64.728301),
  LatLng(-21.517445, -64.729935),
  LatLng(-21.514163, -64.737139),
];

Polyline polyline = Polyline(
  points: points,
  strokeWidth: 6,
  color: Colors.red,
);

class _MapScreenState extends State<MapScreen> {
  double currentZoom = 18;
  LatLng? myPosition;

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      myPosition = LatLng(position.latitude, position.longitude);
      print(myPosition);
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 700,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Información adicional'),
              const SizedBox(height: 20),
              const Text('Podemos poner botones \(^-^)/: un desplegable para elegir la ruta que quieres ver.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                 
                },
                child: const Text('Botón 1'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Estas viendo el boton 2'),
                        content: const Text('no me presiones ahi :v'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Botón 2'),
              ),
            ],
          ),
        );
      },
    );
  }



  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mapa hecho con las patas'),
        backgroundColor: Colors.black12,
      ),
      body: myPosition == null
          ? const CircularProgressIndicator()
          : FlutterMap(
              options: MapOptions(
                  center: myPosition,
                  minZoom: 5,
                  maxZoom: 25,
                  zoom: currentZoom),
              nonRotatedChildren: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: const {
                    'accessToken': MAPBOX_ACCESS_TOKEN,
                    'id': 'mapbox/streets-v12'
                  },
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: myPosition!,
                      builder: (context) {
                        return const Icon(
                          Icons.person_pin,
                          color: Colors.blueAccent,
                          size: 40,
                        );
                      },
                    )
                  ],
                ),
                PolylineLayer(
                  polylines: [polyline],
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        child: Icon(Icons.info),
      ),
    );
  }
}
