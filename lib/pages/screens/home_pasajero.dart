import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rutasmicros/pages/screens/pasajeros/provider/funcionapls.dart';

import 'pasajeros/listar_pasajeros.dart';
import 'pasajeros/prueba_mapa.dart';
import 'pasajeros/seleccionar_ruta.dart';
import 'pasajeros/welcome_pasajeros.dart';

class HomePasajero extends StatefulWidget {
  @override
  _HomePasajeroState createState() => _HomePasajeroState();
}

class _HomePasajeroState extends State<HomePasajero> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          PasajerosPage(),
          ScreenPasajeros(),
          Rutas2Page(), 
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Usuarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Soy el mapa',
          ),
        ],
      ),
    );
  }
}
