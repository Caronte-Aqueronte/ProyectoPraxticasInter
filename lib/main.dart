import 'package:flutter/material.dart';
import 'package:proyecto_tiempo/screens/homeScreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
        fontFamily: 'Roboto', // Establece Roboto como la fuente predeterminada
      ),
      darkTheme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
