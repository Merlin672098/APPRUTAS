import 'package:flutter/material.dart';

class ScreenConductor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Bienvenido ADMIN!',
        style: TextStyle(fontSize: 24),),
      ),
    );
  }
}