import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MostrarUbiConductor extends StatefulWidget {
  //final String user_id;
  final List<String> allUserIds;
  MostrarUbiConductor(/*this.user_id,*/this.allUserIds);

  @override
  _MostrarUbiConductorState createState() => _MostrarUbiConductorState();
}

class _MostrarUbiConductorState extends State<MostrarUbiConductor> {
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

          Set<Marker> markers = Set<Marker>();

          widget.allUserIds.forEach((userId) {
            var userLocations = snapshot.data!.docs
                .where((element) => element.id == userId)
                .toList();

            if (userLocations.isNotEmpty) {
              var userLocation = userLocations[0];

              markers.add(
                Marker(
                  position: LatLng(
                    (userLocation['latitude'] as num).toDouble(),
                    (userLocation['longitude'] as num).toDouble(),
                  ),
                  markerId: MarkerId(userId),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueMagenta,
                  ),
                ),
              );
            }
          });

          if (markers.isNotEmpty) {
            return GoogleMap(
              mapType: MapType.normal,
              markers: markers,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  snapshot.data!.docs
                      .where((element) => widget.allUserIds.contains(element.id))
                      .map((element) => (element['latitude'] as num).toDouble())
                      .reduce((a, b) => a + b) /
                      widget.allUserIds.length,
                  snapshot.data!.docs
                      .where((element) => widget.allUserIds.contains(element.id))
                      .map((element) => (element['longitude'] as num).toDouble())
                      .reduce((a, b) => a + b) /
                      widget.allUserIds.length,
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
                .where((element) => widget.allUserIds.contains(element.id))
                .map((element) => (element['latitude'] as num).toDouble())
                .reduce((a, b) => a + b) /
                widget.allUserIds.length,
            snapshot.data!.docs
                .where((element) => widget.allUserIds.contains(element.id))
                .map((element) => (element['longitude'] as num).toDouble())
                .reduce((a, b) => a + b) /
                widget.allUserIds.length,
          ),
          zoom: 14.47,
        ),
      ),
    );
  }
}
