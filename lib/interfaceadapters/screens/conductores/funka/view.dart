import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogView extends StatefulWidget {
  const LogView({Key? key}) : super(key: key);

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  late Position _currentPosition;
  StreamSubscription<Position>? _locationSubscription;
  late final Timer timer;
  List<String> logs = [];
  String mensaje = 'hola';
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
        print(
            'esta es en 1er plano Latitude: ${currentLocation.latitude}, Longitude: ${currentLocation.longitude}');

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

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.reload();
      logs = sp.getStringList('log') ?? [];
      if (mounted) {
        setState(() {});
      }
      _listenLocation();
      // Enviar mensaje a Firebase
      //final firestore = FirebaseFirestore.instance;
      //final collection = firestore.collection('myCollection');
      //await collection.add({'mensaje': mensaje});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
    _stopListening();
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
    //print('asiduhasi');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs.elementAt(index);
        return Text(log);
      },
    );
  }
}
