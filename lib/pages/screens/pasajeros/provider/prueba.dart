import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteProvider extends ChangeNotifier {
  String _selectedRoute = 'Ruta 1';

  String get selectedRoute => _selectedRoute;

  void setRoute(String newRoute) {
  print('Setting route: $newRoute');
  _selectedRoute = newRoute;
  notifyListeners();
}
}