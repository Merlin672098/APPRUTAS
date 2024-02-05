import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../pages/screens/home_admin.dart';
import '../pages/screens/home_conductor.dart';
import '../pages/screens/home_inspector.dart';
import '../pages/screens/home_pasajero.dart';
import '../pages/screens/inspectores/prueba_web.dart';
import '../pages/screens/pasajeros/HomeVeri.dart';
import '../pruebaprovider.dart';  

class VerificacionRolWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      CollectionReference usuariosCollection =
          FirebaseFirestore.instance.collection('usuarios');
      return StreamBuilder<DocumentSnapshot>(
        stream: usuariosCollection.doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            var data = snapshot.data!.data() as Map<String, dynamic>?;

            if (data != null && data['rol'] != null) {
              String rol = data['rol'];
              bool verificacion = data['verificacion'];
              bool isDarkModeEnabled = data['isDarkModeEnabled'] ?? false;

              Provider.of<ThemeProvider>(context, listen: false)
                  .updateTheme(isDarkModeEnabled);

              if (rol == 'pasajero') {
                if (verificacion == false) {
                  return HomeVeriPasajero();
                }
                return HomePasajero();
              } else if (rol == 'inspector') {
                return const PruebaWeb();
              } else if (rol == 'conductor') {
                return HomeConductor();
              } else if (rol == 'admin') {
                return HomeAdmin();
              } else {
                return Text('Rol desconocido: $rol');
              }
            } else {
              return const Text(
                  'Campo "rol" no encontrado en los datos del usuario');
            }
          } else {
            return const Text(
                'Usuario no encontrado en la colección "usuarios"');
          }
        },
      );
    } else {
      return const Text('Usuario no autenticado');
    }
  }
}

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getRoles() async {
  List roles = [];

  QuerySnapshot querySnapshot = await db.collection('rol').get();

  for (var doc in querySnapshot.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final rol = {
      "id": doc.id,
      "nombre": data['nombre'],
    };
    roles.add(rol);
  }
  return roles;
}
