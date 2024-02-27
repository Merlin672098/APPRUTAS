import 'package:flutter/material.dart';

import 'seleccionar_ruta.dart';


class Vista1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista 1'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapScreen()),
            );
          },
          child: Text('Ir a Vista 2'),
        ),
      ),
    );
  }
}
