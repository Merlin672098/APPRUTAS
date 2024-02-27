import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'conductores/funka/fbs copy.dart';
import 'conductores/funka/service.dart';


class HomeConductor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    final TabController = DefaultTabController(
      length: 2, //numero de los iconos o tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Conductor'),
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
            /*Tab(
              icon: Icon(Icons.contacts),
              text: "Usuarios",
            ),*/
            /*Tab(
              icon: Icon(Icons.contacts),
              text: "Usuarios",
            ),*/
            Tab(
              icon: Icon(Icons.contacts),
              text: "Usuarios",
            ),
          ]),
        ),
        body: TabBarView(children: <Widget>[
          Quevoyahacerwn(),
          //ScreenConductor(),
          //LocationView(),
          Sepuedebanda(),
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
