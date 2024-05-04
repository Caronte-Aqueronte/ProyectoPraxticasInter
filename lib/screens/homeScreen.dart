import 'package:flutter/material.dart';
import 'package:proyecto_tiempo/screens/creditsScreen.dart';
import 'package:proyecto_tiempo/screens/climaScreen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _navBarItems[_selectedIndex].title,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
        backgroundColor: _navBarItems[_selectedIndex].selectedColor,
        leading: Padding(
          padding: const EdgeInsets.only(
              left: 16.0), // Agregar margen a la izquierda
          child: Image(
            image: _imagenes[_selectedIndex],
          ),
        ),
      ),
      body: Center(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color(0xff757575),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _navBarItems,
      ),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.cloudy_snowing),
    title: const Text("Clima"),
    selectedColor: const Color.fromARGB(255, 0, 147, 239),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.theater_comedy),
    title: const Text("Creditos"),
    selectedColor: const Color.fromARGB(255, 188, 188, 0),
  ),
];

final _screens = [ClimaScreen(), CreditsScreen()];

final _imagenes = [
  const AssetImage("weather.png"),
  const AssetImage("meeting.png"),
];
