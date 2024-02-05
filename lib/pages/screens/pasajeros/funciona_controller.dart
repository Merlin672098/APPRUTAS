import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'cons_mapstyle.dart';

class HomeController {
  void onMapCreated(GoogleMapController controller) async {
    controller.setMapStyle(mapStyle);
  }
}
