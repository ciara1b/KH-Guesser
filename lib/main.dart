import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'data/character.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadCharacters();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static List<String> options = ['Character', 'Keyblade', 'Enemy'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text('KHdle'),
          ),
        ),
        body: Center(child: LandingPage(buttonOptions: options)),
      ),
    );
  }
}
