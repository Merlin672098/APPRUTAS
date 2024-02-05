import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:flutter/material.dart';
import 'location_service_repository.dart';
import 'prueba_plano.dart';
import 'file_manager.dart';
class ConductorPage extends StatefulWidget {
  @override
  _ConductorPageState createState() => _ConductorPageState();
}

class _ConductorPageState extends State<ConductorPage> {
  ReceivePort port = ReceivePort();

  String logStr = '';
  late bool isRunning;
  late LocationDto lastLocation;

  @override
  void initState() {
    super.initState();

    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
      (dynamic data) async {
        await updateUI(data);
      },
    );
    initPlatformState();
  }

Future<void> updateUI(dynamic data) async {
    final log = await FileManager.readLogFile();

    LocationDto? locationDto = (data != null) ? LocationDto.fromJson(data) : null;
    await _updateNotificationText(locationDto!);

    setState(() {
      if (data != null) {
        lastLocation = locationDto;
      }
      logStr = log;
    });
  }

  Future<void> _updateNotificationText(LocationDto data) async {
    if (data == null) {
      return;
    }

    await BackgroundLocator.updateNotificationText(
        title: "new location received",
        msg: "${DateTime.now()}",
        bigMsg: "${data.latitude}, ${data.longitude}");
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
    logStr = await FileManager.readLogFile();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
    });
    print('Running ${isRunning.toString()}');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conductor Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido conductor!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                LocationService.startLocationService();
                setState(() {
                  //isLocationServiceRunning = true;
                });
              },
              child: Text('Iniciar servicio de ubicación'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                LocationService.stopLocationService();
                setState(() {
                  //isLocationServiceRunning = false;
                });
              },
              child: Text('Detener servicio de ubicación'),
            ),
          ],
        ),
      ),
    );
  }
}
