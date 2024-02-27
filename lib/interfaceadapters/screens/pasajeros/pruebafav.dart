import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TuPagina extends StatefulWidget {
  @override
  _TuPaginaState createState() => _TuPaginaState();
}

class _TuPaginaState extends State<TuPagina> {
  List<String> miVariableArray2 = [];

  @override
  void initState() {
    super.initState();
    cargarDatos(); // Llama a la función para cargar datos al inicio.
  }

  Future<void> cargarDatos() async {
    // Lógica para cargar datos en miVariableArray2
    miVariableArray2 = await getFavoritedLines();
    setState(() {}); // Actualiza la interfaz gráfica con los nuevos datos
  }

  Future<List<String>> getFavoritedLines() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      QuerySnapshot favoritosSnapshot = await FirebaseFirestore.instance
          .collection('favoritos')
          .where('userId', isEqualTo: user?.uid) // Cambio aquí
          .get();

      if (favoritosSnapshot.docs.isEmpty) {
        return [];
      }

      List<String> lineasFavoritas = favoritosSnapshot.docs
          .map((doc) => doc['lineaId'].toString())
          .toList();

      return lineasFavoritas;
    } catch (e) {
      print("Error in getFavoritedLines: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tu Título'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Otros widgets que puedas tener

            // Widget Text que mostrará el contenido de miVariableArray2
            Text(
              'Contenido de miVariableArray2: ${miVariableArray2.join(', ')}',
              // Puedes personalizar el estilo del texto según tus necesidades
              style: TextStyle(fontSize: 16),
            ),

            // Otros widgets que puedas tener
          ],
        ),
      ),
    );
  }
}
