import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'mostrar_ubi_conductor.dart';
import 'prueba_plano.dart';

class ScreenConductor extends StatefulWidget {
  @override
  _ScreenConductorState createState() => _ScreenConductorState();
}

class _ScreenConductorState extends State<ScreenConductor> {
  late Position _currentPosition;
  StreamSubscription<Position>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _requestPermission();
    
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación en tiempo real'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {
                  _listenLocation();
                  
                  _algoqueponer(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.blue),
                  ),
                ),
                child: Text('Habilita la localización'),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {
                  _stopListening();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.red,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
                child: Text('Detiene la localización'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getLocation() async {
    try {
      _requestPermission();
      await FirebaseFirestore.instance.collection('location').doc().set({
        'latitude': _currentPosition.latitude,
        'longitude': _currentPosition.longitude,
        'linea': 'CE8C2BasK0YDFCEIcMd3',
        'name': 'prueba',
        'parada': true,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    _locationSubscription =
        Geolocator.getPositionStream().handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((Position currentLocation) async {
      print('esta es en 1er plano Latitude: ${currentLocation.latitude}, Longitude: ${currentLocation.longitude}');

      await FirebaseFirestore.instance
          .collection('location')
          .doc(user.uid)
          .set({
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
        'linea': 'CE8C2BasK0YDFCEIcMd3',
        'name': 'prueba',
        'userId': user.uid,
      }, SetOptions(merge: true));
    });
  }
}


  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
    //print('asiduhasi');
  }

  /* _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }*/
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
var status = await Permission.location.request();
  if (status.isGranted) {
    print('Permiso de ubicación concedido');
  } else {
    print('Permiso de ubicación denegado');
  }
    return await Geolocator.getCurrentPosition();
  }


  void _algoqueponer(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black, width: 2.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/win.gif'),
                ),
                const SizedBox(height: 20),
                const Text(
                  "¡Ya estuvo!",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Aceptar"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
