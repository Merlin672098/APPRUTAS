import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'prueba_mapa.dart'; // Asegúrate de importar tu archivo MapScreen correctamente

class Rutas2Page extends StatefulWidget {
  @override
  _PasajerosPageState createState() => _PasajerosPageState();
}

class _PasajerosPageState extends State<Rutas2Page> {
  static const List<LatLng> ruta1 = [
    LatLng(-21.514163, -64.737140),
    LatLng(-21.521457, -64.742304),
    LatLng(-21.523080, -64.740487),
    LatLng(-21.527162, -64.739527),
    LatLng(-21.532713, -64.740717),
    
  ];

  static const List<LatLng> ruta2 = [
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
    
  ];

static const List<LatLng> rutaBanderitaAzul = [
  LatLng(-21.534556, -64.767806),
  LatLng(-21.534556, -64.776194),
  LatLng(-21.533528, -64.775135),
  LatLng(-21.533639, -64.774223),
  LatLng(-21.532067, -64.772421),
  LatLng(-21.531336, -64.772204),
  LatLng(-21.531589, -64.771139),
  LatLng(-21.534767, -64.769812),
  LatLng(-21.534594, -64.769197),
  LatLng(-21.533334, -64.768315),
];

  

  List<LatLng> rutaSeleccionada = ruta1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pixel de seleccion de ruta',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            DropdownButton<List<LatLng>>(
              value: rutaSeleccionada,
              onChanged: (value) {
                setState(() {
                  rutaSeleccionada = value!;
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(rutaSeleccionada: rutaSeleccionada),
                  ),
                );
              },
              items: const [
                DropdownMenuItem(
                  value: ruta1,
                  child: Text('Ruta 1'),
                ),
                DropdownMenuItem(
                  value: ruta2,
                  child: Text('Ruta 2'),
                ),
                DropdownMenuItem(
                  value: rutaBanderitaAzul,
                  child: Text('Ruta de veras ?'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
