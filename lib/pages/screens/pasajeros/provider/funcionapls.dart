import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../prueba_mapa.dart';

class MapScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (context) => RouteProvider()),
        // Otros providers si es necesario
      ],
      child: MapScreen(),
    );
  }
}

