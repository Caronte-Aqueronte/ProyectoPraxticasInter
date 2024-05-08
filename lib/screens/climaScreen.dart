import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_tiempo/models/direccionVientoInfo.dart';
import 'package:proyecto_tiempo/models/lectura.dart';

class ClimaScreen extends StatefulWidget {
  final String cityName;
  final String color;
  const ClimaScreen({super.key, required this.cityName, required this.color});

  @override
  // ignore: library_private_types_in_public_api
  _ClimaScreenState createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  Lectura? lectura;
  bool _isLoading = false;
  String nombreEstacion = "";
  @override
  void initState() {
    super.initState();
    if (widget.cityName == "Conce") {
      nombreEstacion = "Concepción";
    } else {
      nombreEstacion = widget.cityName;
    }
    // Llamar a la función getEstacion al inicio para cargar los datos iniciales
    getEstacion(widget.cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(int.parse('FF${widget.color}', radix: 16)),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context); // Regresar a la pantalla anterior
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                Text(
                  nombreEstacion,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 40.0), // Ajuste de espaciado
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  constraints: const BoxConstraints(maxWidth: 400.0),
                  child: _buildContent(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getEstacion(
              widget.cityName); // Recargar los datos al presionar el botón
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
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
      return const Center(
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

  Future<void> getEstacion(String nombreEstacion) async {
    setState(() {
      _isLoading = true; // Mostrar indicador de carga
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://cyt.cunoc.edu.gt/index.php/Ultimo-Registro/$nombreEstacion'),
      );

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
