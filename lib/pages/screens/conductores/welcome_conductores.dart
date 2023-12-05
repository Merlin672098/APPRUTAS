import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'mostrar_ubi_conductor.dart';

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
        title: Text('live location tracker'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              _getLocation();
            },
            child: const Text('AÑADE MI UBICACION'),
          ),
          TextButton(
            onPressed: () {
              _listenLocation();
            },
            child: const Text('Habilita la localizacion'),
          ),
          TextButton(
            onPressed: () {
              _stopListening();
            },
            child: const Text('Detiene la localizacion'),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('location').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text(snapshot.data!.docs[index]['name'].toString()),
                      subtitle: Row(
                        children: [
                          Text(snapshot.data!.docs[index]['latitude']
                              .toString()),
                          SizedBox(
                            width: 20,
                          ),
                          Text(snapshot.data!.docs[index]['longitude']
                              .toString()),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.directions),
                        onPressed: () {
                          List<String> allUserIds =
                              snapshot.data!.docs.map((doc) => doc.id).toList();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                MostrarUbiConductor(allUserIds),
                          ));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _getLocation() async {
    try {
      await FirebaseFirestore.instance.collection('location').doc('prueba').set({
        'latitude': _currentPosition.latitude,
        'longitude': _currentPosition.longitude,
        'linea':'CE8C2BasK0YDFCEIcMd3',
        'name': 'prueba',
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    _locationSubscription =
        Geolocator.getPositionStream().handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((Position currentLocation) async {
      await FirebaseFirestore.instance.collection('location').doc('prueba').set({
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
        'linea':'CE8C2BasK0YDFCEIcMd3',
        'name': 'prueba',
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
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

    return await Geolocator.getCurrentPosition();
  }
}
