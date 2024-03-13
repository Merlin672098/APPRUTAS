import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:rutasmicros/interfaceadapters/screens/conductores/funka/cronometro.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rutasmicros/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../domain/entities/ubicacion.dart';

Future<Position> _requestPermission() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('La ubi no esta disponible');
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Los permisos fueron denegados');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('La ubicaion esta permanentementedenegada');
  }
  var status = await Permission.location.request();
  if (status.isGranted) {
    print('Permiso de ubicación concedido');
  } else {
    print('Permiso de ubicación denegado');
  }
  return await Geolocator.getCurrentPosition();
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  //User? currentUser = await getCurrentUser();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: false,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        final position = await _getLocation();
        flutterLocalNotificationsPlugin.show(
          888,
          'COOL SERVICE',
          'Awesome $position',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
      }
    }

    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    final position = await _getLocation();
    //enviarUbicacion(position);
    _writeToFirebase(device, position);
    _writeToFirebase2(device, position);
    //API
    //await _writeToFirebase(device, position);
    print('FLUTTER BACKGROUND SERVICE: $position.latitude');
    service.invoke(
      'update',
      {
        "device": device,
        "current_location": {
          "latitude": position.latitude,
          "longitude": position.longitude,
        },
      },
    );
  });
}
/*
Future<User?> getCurrentUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  return user;
}*/

Future<void> _writeToFirebase(String? device, Position position) async {
  User? user = FirebaseAuth.instance.currentUser;

  try {
    await FirebaseFirestore.instance.collection('location').doc(user?.uid).set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'linea': 'CE8C2BasK0YDFCEIcMd3',
      'name': 'prueba',
      'userId': user?.uid,
    }, SetOptions(merge: true));

    print('mandando ando');
  } catch (e) {
    print('Error : $e');
  }
}

Future<void> _writeToFirebase2(String? device, Position position) async {
  User? user = FirebaseAuth.instance.currentUser;

  try {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('prueba2').doc(user?.uid);

    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      List<dynamic> currentLocations =
          (docSnapshot.data() as Map<String, dynamic>)['locations'];

      List<dynamic> updatedLocations = [
        ...currentLocations,
        _createGeoPoint(position)
      ];

      await docRef.update({
        'locations': updatedLocations,
      });

      print('Nueva posición agregada');
    } else {
      await docRef.set({
        'locations': [_createGeoPoint(position)],
        'linea': 'CE8C2BasK0YDFCEIcMd3',
        'name': 'prueba',
        'userId': user?.uid,
        //variable de prueba para saber si se completo el recorrido
        'recorridoCompleto': false
      });
      String createdDocId = docRef.id;
      print('Documento creado para la prueba idk $createdDocId');
      String storedDocId = createdDocId;
      

      print('Documento creado');
    }
  } catch (e) {
    print('Error : $e');
  }
}

GeoPoint _createGeoPoint(Position position) {
  return GeoPoint(position.latitude, position.longitude);
}

Future<Position> _getLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw 'Location services are disabled.';
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Location permissions are denied.';
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw 'Location permissions are permanently denied, we cannot request permissions.';
  }

  return await Geolocator.getCurrentPosition();
}

Future<void> enviarUbicacion(Position position) async {
  WebSocketChannel channel;

  try {
    Map<String, dynamic> posicionMapa = {
      'latitud': position.latitude,
      'longitud': position.longitude,
      'linea': 'CE8C2BasK0YDFCEIcMd3',
      'name': 'prueba',
      'userId': 'GK75zf08BNZipZibFjGpVJbQ5W93',
    };
    //String posicionJson = jsonEncode(posicionMapa);
    String mensaje2 = 'hola2';
    channel = WebSocketChannel.connect(
        Uri.parse('ws://nfc.api.dev.404.codes/api/auth'));
    //nfc.api.dev.404.code/api/auth
    channel.sink.add(mensaje2);

    channel.stream.listen((message) {
      print(message);
      channel.sink.close();
    });
  } catch (e) {
    print(e);
  }
}

class Sepuedebanda extends StatefulWidget {
  const Sepuedebanda({Key? key}) : super(key: key);

  @override
  State<Sepuedebanda> createState() => _SepuedebandaStateState();
}

class _SepuedebandaStateState extends State<Sepuedebanda> {
  String text = "Stop Service";
  late Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
    initializeService();
    _requestPermission();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            //title: const Text('Service App con weas bonitas'),
            ),
        body: Column(
          children: [
            StreamBuilder<Map<String, dynamic>?>(
              stream: FlutterBackgroundService().on('update'),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final data = snapshot.data!;
                String? device = data["device"];
                Map<String, dynamic>? locationData = data["current_location"];

                if (device == null || locationData == null) {
                  return const Center(
                    child: Text('Error: Missing data'),
                  );
                }

                double? latitude = locationData["latitude"];
                double? longitude = locationData["longitude"];

                if (latitude == null || longitude == null) {
                  return const Center(
                    child: Text('Error: Missing location coordinates'),
                  );
                }

                return Column(
                  children: [
                    Text(device),
                    Text('Latitude: $latitude\nLongitude: $longitude'),
                  ],
                );
              },
            ),
            ElevatedButton(
              child: const Text("Foreground Mode"),
              onPressed: () {
                FlutterBackgroundService().invoke("setAsForeground");
              },
            ),
            ElevatedButton(
              child: const Text("Background Mode"),
              onPressed: () {
                FlutterBackgroundService().invoke("setAsBackground");
              },
            ),
            ElevatedButton(
              child: Text(text),
              onPressed: () async {
                final service = FlutterBackgroundService();
                var isRunning = await service.isRunning();
                if (isRunning) {
                  service.invoke("stopService");
                } else {
                  service.startService();
                }

                if (!isRunning) {
                  text = 'Stop Service';
                } else {
                  text = 'Start Service';
                  //iniciarCronometro();
                }
                setState(() {});
              },
            ),
            //cronometro
            //Text('Tiempo transcurrido: $_seconds segundos'),
            Cronometro(), //Cronometro
          ],
        ),
      ),
    );
  }
}

class LogView extends StatefulWidget {
  const LogView({Key? key}) : super(key: key);

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  late Position _currentPosition;
  StreamSubscription<Position>? _locationSubscription;
  late final Timer timer;
  List<String> logs = [];
  String mensaje = 'hola';
  bool listenLocation = true;
  Ubicacion? _currentLocation;

  void _updateLocation(Position currentLocation) async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = Ubicacion(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.reload();
      logs = sp.getStringList('log') ?? [];
      if (mounted) {
        setState(() {});
      }
      //_listenLocation();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
    _stopListening();
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
    //print('asiduhasi');
  }

  void toggleLocationListening() {
    setState(() {
      listenLocation = !listenLocation;
    });
    if (!listenLocation) {
      _locationSubscription?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs.elementAt(index);
              return Text(log);
            },
          ),
        ),
      ],
    );
  }
}
