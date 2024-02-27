import 'dart:io';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'dart:isolate';

import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'location_callback_handler.dart';

class LocationService {
  static const String _isolateName = "LocatorIsolate";
  static ReceivePort port = ReceivePort();

  

  static void startLocationService() {
    Map<String, dynamic> data = {'countInit': 1};
    print('Iniciando servicio de ubicación en segundo plano');

    BackgroundLocator.registerLocationUpdate(
      LocationCallbackHandler.callback,
      initCallback:  LocationCallbackHandler.initCallback,
      initDataCallback: data,
      disposeCallback:  LocationCallbackHandler.disposeCallback,
      autoStop:
          false,
      iosSettings: const IOSSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        distanceFilter: 0,
      ),
      androidSettings: const AndroidSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval:
            2, 
        distanceFilter: 0,
        client: LocationClient.google,
        androidNotificationSettings: AndroidNotificationSettings(
            notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                    'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIcon: '',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                    LocationCallbackHandler.notificationCallback
            ),
      ),
    );
  }

  



static void callbackHandler(LocationDto locationDto) async {
  print('CallbackHandler llamado con ubicación: $locationDto');

  final SendPort? send = IsolateNameServer.lookupPortByName(_isolateName);
  send?.send(locationDto);

  print('Ubicación en segundo plano: ${locationDto.latitude}, ${locationDto.longitude}');

  print('Mensaje desde callbackHandler en segundo plano');

  await sendLocationToFirestore(locationDto.latitude, locationDto.longitude);
}



  static void printLocationInSecondPlan(double latitude, double longitude) {
    print(
        'Ubicación en segundo plano: Latitude: $latitude, Longitude: $longitude');
  }

  static Future<void> sendLocationToFirestore(
      double latitude, double longitude) async {
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
    }
  }

  static void stopLocationService() {
    IsolateNameServer.removePortNameMapping(_isolateName);
    BackgroundLocator.unRegisterLocationUpdate();
  }
}
