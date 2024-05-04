import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_tiempo/models/direccionVientoInfo.dart';
import 'package:proyecto_tiempo/models/lectura.dart';

class ClimaScreen extends StatefulWidget {
  ClimaScreen({Key? key}) : super(key: key);

  @override
  _ClimaScreenState createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  Lectura? lectura;
  bool _isLoading = false;
  String estacion = "";

  @override
  void initState() {
    super.initState();
    // Llamar a la función getCunoc al inicio para cargar los datos iniciales
    getCunoc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 0, 147, 239),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButtonWithText(Icons.search, 'Cunoc', getCunoc),
                _buildButtonWithText(Icons.settings, 'Cantel', getCantel),
                _buildButtonWithText(
                    Icons.settings, 'Concepción', getConcepcion),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  constraints: BoxConstraints(maxWidth: 400.0),
                  child: _buildContent(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getEstacion(estacion); // Llamar a la función correspondiente
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildButtonWithText(
    IconData iconData,
    String buttonText,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        IconButton(
          icon: Icon(iconData),
          onPressed: onPressed,
          iconSize: 32.0,
          color: Colors.white,
        ),
        const SizedBox(height: 8.0),
        Text(
          buttonText,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return CircularProgressIndicator();
    } else if (lectura != null) {
      return Column(
        children: [
          _buildListTile("clock.png", 'Fecha y Hora', lectura!.fechahora),
          _buildListTile(
            "temperature.png",
            'Temperatura',
            '${lectura!.temperatura} °C',
          ),
          _buildListTile("humidity.png", 'Humedad', '${lectura!.humedad}%'),
          _buildListTile("solar.png", 'Radiación', '${lectura!.radiacion}'),
          _buildListTile(
            obtenerDireccionViento(lectura!.direccion).rutaImagen,
            'Dirección del Viento',
            '${lectura!.direccion}° - ${obtenerDireccionViento(lectura!.direccion).nombre}',
          ),
          _buildListTile(
            "storm.png",
            'Velocidad del Viento',
            '${lectura!.velocidad} km/h',
          ),
          _buildListTile(
            "raining.png",
            'Precipitación',
            '${lectura!.precipitacion} mm/h - ${categorizarPrecipitacion(lectura!.precipitacion)}',
          ),
        ],
      );
    } else {
      return Center(
        child: Text('No se ha cargado ninguna lectura'),
      );
    }
  }

  Widget _buildListTile(String imageUrl, String title, String value) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imageUrl),
        backgroundColor: Colors.transparent,
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(value),
    );
  }

  void getConcepcion() {
    estacion = "Conce";
    getEstacion(estacion);
  }

  void getCunoc() {
    estacion = "Cunoc";
    getEstacion(estacion);
  }

  void getCantel() {
    estacion = "Cantel";
    getEstacion(estacion);
  }

  Future<void> getEstacion(String nombreEstacion) async {
    setState(() {
      _isLoading = true; // Mostrar indicador de carga
    });

    try {
      final response = await http.get(Uri.parse(
          'https://cyt.cunoc.edu.gt/index.php/Ultimo-Registro/$nombreEstacion'));

      if (response.statusCode == 200) {
        setState(() {
          lectura = Lectura.fromJson(
              jsonDecode(response.body) as Map<String, dynamic>);
        });
      } else {
        throw Exception('Failed to load Lectura');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Manejar el error aquí según sea necesario
    } finally {
      setState(() {
        _isLoading = false; // Ocultar indicador de carga
      });
    }
  }

  DireccionVientoInfo obtenerDireccionViento(double grados) {
    List<DireccionVientoInfo> direcciones = [
      DireccionVientoInfo('Norte', 'norte.png'),
      DireccionVientoInfo('Noreste', 'noreste.png'),
      DireccionVientoInfo('Este', 'este.png'),
      DireccionVientoInfo('Sureste', 'sureste.png'),
      DireccionVientoInfo('Sur', 'sur.png'),
      DireccionVientoInfo('Suroeste', 'suroeste.png'),
      DireccionVientoInfo('Oeste', 'oeste.png'),
      DireccionVientoInfo('Noroeste', 'noroeste.png'),
    ];

    grados = (grados % 360 + 360) % 360;
    int indice = ((grados / 45).round() % 8);
    return direcciones[indice];
  }

  String categorizarPrecipitacion(double mmPorHora) {
    if (mmPorHora == 0) {
      return "No hay lluvia";
    } else if (mmPorHora < 2) {
      return "Débil";
    } else if (mmPorHora >= 2 && mmPorHora <= 15) {
      return "Moderada";
    } else if (mmPorHora > 15 && mmPorHora <= 30) {
      return "Fuerte";
    } else if (mmPorHora > 30 && mmPorHora <= 60) {
      return "Muy fuerte";
    } else {
      return "Intensidad extrema";
    }
  }
}
