import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutasmicros/responsive/Items.dart';
import '../constants.dart';
import '../interfaceadapters/screens/conductores/mostrar_ubi_conductor.dart';
import '../util/my_box.dart';
import '../util/my_tile.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  String pixeldeAsociacion = '';
  GoogleMapController? _controller;
  bool _added = false;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    cargarAsociacion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer
            myDrawer,
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 4,
                    child: SizedBox(
                      width: double.infinity,
                      child: GridView.builder(
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          DataItem currentItem = data[index];
                          return MyBox(
                            title: currentItem.title,
                            value: currentItem.value,
                          );
                        },
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(13.0),
                    child: Text('mapa'),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('location')
                          //.where('linea', isEqualTo: widget.userId)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (_added) {
                          //mymap(snapshot);
                        }
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        Set<Marker> markers = Set<Marker>();

                        snapshot.data!.docs.forEach((document) {
                          bool isParada = document['parada'] ?? false;
                          Color markerColor =
                              isParada ? Colors.red : Colors.blue;

                          markers.add(
                            Marker(
                              position: LatLng(
                                (document['latitude'] as num).toDouble(),
                                (document['longitude'] as num).toDouble(),
                              ),
                              markerId: MarkerId(document.id),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                isParada
                                    ? BitmapDescriptor.hueRed
                                    : BitmapDescriptor.hueBlue,
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
                                        .map((marker) =>
                                            marker.position.latitude)
                                        .reduce((a, b) => a + b) /
                                    markers.length,
                                markers
                                        .map((marker) =>
                                            marker.position.longitude)
                                        .reduce((a, b) => a + b) /
                                    markers.length,
                              ),
                              zoom: 14.47,
                            ),
                            onMapCreated:
                                (GoogleMapController controller) async {
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

            // second half of page
            Expanded(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('LINEAS'),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('lineas')
                          .where('idasociacion',
                              isEqualTo: pixeldeAsociacion) //widget.userId
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('Linea: ' +
                                  snapshot.data!.docs[index]['nombre']
                                      .toString()),
                              /*subtitle: Row(
                                children: [
                                  Text('Latitude: '+snapshot.data!.docs[index]['latitude'].toString()),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text('Longitude: '+snapshot.data!.docs[index]['longitude'].toString()),
                                ],
                              ),*/
                              trailing: IconButton(
                                icon: Icon(Icons.directions),
                                onPressed: () {
                                  List<String> allUserIds = snapshot.data!.docs
                                      .map((doc) => doc.id)
                                      .toList();
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
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Usuarios en Linea'),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('location')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('Usuario: ' +
                                  snapshot.data!.docs[index]['name']
                                      .toString()),
                              subtitle: Row(
                                children: [
                                  Text('Latitude: ' +
                                      snapshot.data!.docs[index]['latitude']
                                          .toString()),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text('Longitude: ' +
                                      snapshot.data!.docs[index]['longitude']
                                          .toString()),
                                ],
                              ),
                              /*trailing: IconButton(
                                icon: Icon(Icons.directions),
                                onPressed: () {
                                  List<String> allUserIds = snapshot.data!.docs.map((doc) => doc.id).toList();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MostrarUbiConductor(allUserIds),
                                  ));
                                },
                              ),*/
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> cargarAsociacion() async {
    try {
      pixeldeAsociacion = (await getDataUser())!;
      print('llega ? $pixeldeAsociacion');
    } catch (e) {
      print("Error in cargarAsociacion: $e");
      throw e;
    }
  }

  Future<String?> getDataUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      QuerySnapshot favoritosSnapshot = await FirebaseFirestore.instance
          .collection('USER_ASOCI')
          .where('id_user', isEqualTo: user?.uid)
          .get();

      if (favoritosSnapshot.docs.isEmpty) {
        return null;
      }

      String idasociacion =
          favoritosSnapshot.docs.first['id_asociacion'].toString();
      print(
          'Este es el idasociacion al que pertenece el usuario $idasociacion');
      return idasociacion;
    } catch (e) {
      print("Error in getDataUser: $e");
      throw e;
    }
  }

  /*void _drawPolyline() {
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
  }*/
}
