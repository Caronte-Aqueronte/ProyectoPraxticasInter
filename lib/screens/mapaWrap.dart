// ignore: file_names
import 'package:flutter/material.dart';
import 'package:proyecto_tiempo/screens/mapaGenerador.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Texto "Escoge una estacion"
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0), // Espaciado vertical
            child: const Text(
              'Elije una estación',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          // Espacio para los indicadores (color-nombre)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0), // Espaciado vertical
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIndicator(const Color(0xFF8e2013),
                    'Concepción'), // Color y nombre del indicador 2
                _buildIndicator(const Color(0xFF015d82),
                    'Cunoc'), // Color y nombre del indicador 1
                _buildIndicator(const Color(0xFFa81366),
                    'Cantel'), // Color y nombre del indicador 3
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo del contenedor
                borderRadius: BorderRadius.circular(10.0), // Borde redondeado
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Color de la sombra
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Desplazamiento de la sombra
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width - 30,
              height: MediaQuery.of(context).size.height,
              child: const SvgMapWidget(svgImage: "MapaXela.svg"),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIndicator(Color color, String name) {
    return Row(
      children: [
        Container(
          width: 20.0, // Ancho del cuadro de color
          height: 20.0, // Altura del cuadro de color
          color: color, // Color del cuadro
        ),
        const SizedBox(
            width:
                8.0), // Espaciado horizontal entre el cuadro de color y el texto
        Text(
          name,
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
