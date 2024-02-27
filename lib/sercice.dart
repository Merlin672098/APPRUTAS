import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/actions.dart';

const platform = MethodChannel('com.yourdomain.yourapp/background_service');

void startService(Intent intent) async {
  try {
    await platform.invokeMethod('startService');
  } on PlatformException catch (e) {
    print('Failed to start service: ${e.message}');
  }
}