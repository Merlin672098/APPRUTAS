import 'dart:async';

import 'package:background_locator_2/location_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'location_service_repository.dart';

@pragma('vm:entry-point')
class LocationCallbackHandler {
  
  @pragma('vm:entry-point')
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    await myLocationCallbackRepository.init(params);
  }

  @pragma('vm:entry-point')
  static Future<void> disposeCallback() async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    await myLocationCallbackRepository.dispose();
  }

  @pragma('vm:entry-point')
  static Future<void> callback(LocationDto locationDto) async {
    
    print('puta');
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    await myLocationCallbackRepository.callback(locationDto);
    double latitude = locationDto.latitude;
    double longitude = locationDto.longitude;
    print('puta2');
    //await LocationCallbackHandler.sendLocationToFirestore(latitude, longitude);
    print('puta3');
  }

  @pragma('vm:entry-point')
  static Future<void> notificationCallback() async {
    print('***notificationCallback');
  }

  static Future<void> sendLocationToFirestore(
      double latitude, double longitude) async {
        print('puta');
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('location')
          .doc(user.uid)
          .set({
        'latitude': latitude,
        'longitude': longitude,
        'linea': 'CE8C2BasK0YDFCEIcMd3',
        'name': 'prueba',
        'userId': user.uid,
      }, SetOptions(merge: true));
      print('Ubicación enviada a Firestore');
    }
  }
}
