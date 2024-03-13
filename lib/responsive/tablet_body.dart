import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants.dart';
import '../util/my_box.dart';
import '../util/my_tile.dart';

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({Key? key}) : super(key: key);

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  GoogleMapController? _controller;
  bool _added = false;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      drawer: myDrawer,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // first 4 boxes in grid
            AspectRatio(
              aspectRatio: 4,
              child: SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  itemCount: 3,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return MyBox(title: 'Total Sales', value: '\$125,000');
                  },
                ),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('location')
                          //.where('linea', isEqualTo: widget.userId)
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
                              //controller.setMapStyle(themeProvider.getMapStyle());

                              setState(() {
                                _controller = controller;
                                _added = true;
                                //_drawPolyline();
                                //_getCurrentLocation();
                              });
                            },
                          );
                        } else {
                          return Center(child: Text('No hay marcadores.'));
                        }
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
