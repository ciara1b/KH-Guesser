import 'dart:async';

import 'package:flutter/material.dart';
import 'package:khdle/widgets/assets.dart';

import 'widgets/data_loader.dart';
import 'screens/landing_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(dataReady);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static List<String> options = ['Character', 'Keyblade'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColours.white,
        fontFamily: 'PRGothIWA',
      ),
      home: Scaffold(
        body: Center(child: LandingPage(buttonOptions: options)),
      ),
    );
  }
}
