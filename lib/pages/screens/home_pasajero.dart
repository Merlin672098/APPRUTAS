import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rutasmicros/pages/screens/pasajeros/provider/funcionapls.dart';

import 'pasajeros/listar_pasajeros.dart';
import 'pasajeros/prueba_mapa.dart';
import 'pasajeros/seleccionar_ruta.dart';
import 'pasajeros/volar.dart';
import 'pasajeros/welcome_pasajeros.dart';

class HomePasajero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    final TabController = DefaultTabController(
      length: 4, //numero de los iconos o tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pasajero'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
          bottom: const TabBar(indicatorColor: Colors.red, tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home),
              text: "Home",
            ),
            Tab(
              icon: Icon(Icons.contacts),
              text: "Usuarios",
            ),
            Tab(
              icon: Icon(Icons.map),
              text: "Soy el mapa",
            ),
            Tab(
              icon: Icon(Icons.home),
              text: "MAPAMAPA",
            ),
          ]),
        ),
        body: TabBarView(children: <Widget>[
          PasajerosPage(),
          ScreenPasajeros(),
          Rutas2Page(), 
          Volar(),

        ]),
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabController,
    );
  }


 
}
