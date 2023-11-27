import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Levitar extends StatefulWidget {
  final String user_id;
  Levitar(this.user_id);

  @override
  _LevitarState createState() => _LevitarState();
}

class _LevitarState extends State<Levitar> {
  late GoogleMapController _controller;
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('location').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (_added) {
            mymap(snapshot);
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return GoogleMap(
            mapType: MapType.normal,
            markers: {
              Marker(
                position: LatLng(
                  snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['latitude'],
                  snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.user_id)['longitude'],
                ),
                markerId: MarkerId('id'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueMagenta,
                ),
              ),
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
                snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
              ),
              zoom: 14.47,
            ),
            onMapCreated: (GoogleMapController controller) async {
              setState(() {
                _controller = controller;
                _added = true;
              });
            },
          );
        },
      ),
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            snapshot.data!.docs.singleWhere(
              (element) => element.id == widget.user_id)['latitude'],
            snapshot.data!.docs.singleWhere(
              (element) => element.id == widget.user_id)['longitude'],
          ),
          zoom: 14.47,
        ),
      ),
    );
  }
}
