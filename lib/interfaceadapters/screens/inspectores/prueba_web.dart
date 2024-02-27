import 'package:flutter/material.dart';

import '../../../responsive/desktop_body.dart';
import '../../../responsive/mobile_body.dart';
import '../../../responsive/responsive_layout.dart';
import '../../../responsive/tablet_body.dart';


class PruebaWeb extends StatelessWidget {
  const PruebaWeb({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: ResponsiveLayout(
        mobileBody: const MobileScaffold(),
        tabletBody: const TabletScaffold(),
        desktopBody: const DesktopScaffold(),
      ),
    );
  }
}
