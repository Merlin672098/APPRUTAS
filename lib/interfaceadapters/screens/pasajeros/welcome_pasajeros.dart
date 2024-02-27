import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ScreenPasajeros extends StatefulWidget {
  @override
  _ScreenPasajerosState createState() => _ScreenPasajerosState();
}

class _ScreenPasajerosState extends State<ScreenPasajeros> {
  String locationMessage = 'ubi actual';
  late String lat;
  late String long;

  Future<Position> _getUbicacionActual() async {
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

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 100);
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();

      setState(() {
        locationMessage = 'Latitud: $lat , longitud: $long';
      });
    });
  }

  Future<void> _openMap(String lat, String long) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'No $googleURL';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(locationMessage, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    _getUbicacionActual().then((value) {
                      lat = '${value.latitude}';
                      long = '${value.longitude}';
                      setState(() {
                        locationMessage = 'Latitud: $lat , Longitud" $long';
                      });
                      _liveLocation();
                    });
                  },
                  child: const Text('Tu ubi actual')),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    _openMap(lat, long);
                  },
                  child: const Text('Abrir Google Maps'))
            ],
          ),
        ),
      );
}
