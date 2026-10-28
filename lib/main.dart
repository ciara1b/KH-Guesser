import 'package:flutter/material.dart';
import 'package:khdle/models/keyblade.dart';
import 'screens/landing_page.dart';
import 'models/character.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadCharacters();
  await loadKeyblades();
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
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        fontFamily: 'PRGothIWA',
      ),
      home: Scaffold(
        body: Center(child: LandingPage(buttonOptions: options)),
      ),
    );
  }
}
