import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cronometro extends StatefulWidget {
  const Cronometro({Key? key}) : super(key: key);
  @override
  _CronometroState createState() => _CronometroState();
}

class _CronometroState extends State<Cronometro> {
  int milisegundos = 0;
  late Timer timer;
  bool estaCorriendo = false;

  void detenerCronometro() {
    timer.cancel();
    estaCorriendo = false;
  }

  void iniciarCronometro() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        milisegundos += 100;
      });
    });
    estaCorriendo = true;
  }

  String formatearTiempo(){
    Duration duracion = Duration(milliseconds: this.milisegundos);
    int horas = duracion.inHours;
    int minutos = duracion.inMinutes.remainder(60);
    int segundos = duracion.inSeconds.remainder(60);
    int milisegundos = duracion.inMilliseconds.remainder(1000);
    return "${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}:${milisegundos.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
         Text(formatearTiempo(), style: TextStyle(fontSize: 50)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CupertinoButton(child: Text('Iniciar'), onPressed: iniciarCronometro),
        CupertinoButton(child: Text('Detener'), onPressed: detenerCronometro),

          ],
        )
      ],
    );
  }
}
