import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rutasmicros/pruebaprovider.dart';

import 'pasajeros/favoritos.dart';
import 'pasajeros/listar_pasajeros.dart';
import 'pasajeros/tarifas/tarifas_page.dart';

class HomePasajero extends StatefulWidget {
  @override
  _HomePasajeroState createState() => _HomePasajeroState();
}

class _HomePasajeroState extends State<HomePasajero> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = [
      FavoritosPage(),
      PasajerosPage(),
    ];

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Admin',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
          home: Scaffold(
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
            body: _widgetOptions[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'TUS RUTAS',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.directions_walk),
                  label: 'TODAS LAS RUTAS',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.red,
              onTap: _onItemTapped,
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 105, 186, 253),
                    ),
                    child: Text(
                      'Drawer Header',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(
                      'Tema Oscuro',
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Switch(
                      value: themeProvider.isDarkModeEnabled,
                      onChanged: (value) {
                        themeProvider.updateTheme(value);
                        _updateThemeInDatabase(value);
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.price_check),
                    title: Text(
                      'Tarifas',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TarifasPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text(
                      'Cerrar Sesion',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      FirebaseAuth.instance.signOut(); // Cierra el drawer
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateThemeInDatabase(bool isDarkModeEnabled) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      FirebaseFirestore.instance.collection('usuarios').doc(uid).update({'isDarkModeEnabled': isDarkModeEnabled});
    }
  }

}
