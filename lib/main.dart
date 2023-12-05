import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rutasmicros/firebase_options.dart';
import 'package:rutasmicros/utils.dart';
import 'pages/login/auth_page.dart';
import 'pages/login/verify_email_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //inicializar las notificaciones asdgajshgd

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseApi().initNotifications();


  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static const String title = 'Firebase Auth';
  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        //theme: ThemeData.dark(),
        home: MainPage(),
        debugShowCheckedModeBanner: false,
      );
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Algo salio mal!'));
          } else if (snapshot.hasData) {
            return VerifyEmailPage();
          } else {
            return AuthPage();
          }
        },
      ));
}
