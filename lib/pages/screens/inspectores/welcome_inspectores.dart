import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../conductores/mostrar_ubi_conductor.dart';

//import 'mostrar_ubi_conductor.dart';

class ScreenInspectores extends StatefulWidget {
  @override
  _ScreenConductorState createState() => _ScreenConductorState();
}

class _ScreenConductorState extends State<ScreenInspectores> {
  late Position _currentPosition;
  StreamSubscription<Position>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    //_requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('live location tracker'),
      ),
      body: Column(
        children: [
          /*TextButton(
            onPressed: () {
              //_getLocation();
            },
            child: const Text('AÑADE MI UBICACION'),
          ),*/
          /*TextButton(
            onPressed: () {
              _listenLocation();
              _algoqueponer(context);
            },
            child: const Text(
              'Habilita la localización',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: Colors.blue, 
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _stopListening();
            },
            child: const Text(
              'Detiene la localización',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: Colors.red, 
              ),
            ),
          ),*/

          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('location').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
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
                          const SizedBox(
                            width: 20,
                          ),
                          Text(snapshot.data!.docs[index]['longitude']
                              .toString()),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.directions),
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
                const SizedBox(
                  width: 80,
                  height: 80,
                  //child: Image.asset('assets/negacion.gif'),
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
