import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:proyecto_tiempo/screens/climaScreen.dart';
import 'package:xml/xml.dart';
import 'package:path_drawing/path_drawing.dart';

class Country {
  final String id;
  final String path;
  final String color;
  final String name;

  Country({
    required this.id,
    required this.path,
    required this.color,
    required this.name,
  });
}

class SvgMapWidget extends StatefulWidget {
  final String svgImage;

  const SvgMapWidget({Key? key, required this.svgImage}) : super(key: key);

  @override
  _SvgMapWidgetState createState() => _SvgMapWidgetState();
}

class _SvgMapWidgetState extends State<SvgMapWidget> {
  late Future<List<Country>> _countriesFuture;

  @override
  void initState() {
    super.initState();
    _countriesFuture = _loadSvgImage();
  }

  Future<List<Country>> _loadSvgImage() async {
    try {
      final String svgString = await rootBundle.loadString(widget.svgImage);
      final XmlDocument document = XmlDocument.parse(svgString);
      final List<Country> loadedCountries = _parseSvg(document);
      return loadedCountries;
    } catch (e) {
      print('Error loading SVG: $e');
      return []; // Return an empty list in case of error
    }
  }

  List<Country> _parseSvg(XmlDocument document) {
    final List<Country> maps = [];
    final List<XmlElement> paths = document.findAllElements('path').toList();

    for (var element in paths) {
      final String partId = element.getAttribute('id') ?? '';
      final String partPath = element.getAttribute('d') ?? '';
      final String name = element.getAttribute('name') ?? '';
      final String color = element.getAttribute('color') ?? 'D7D3D2';
      maps.add(Country(id: partId, path: partPath, color: color, name: name));
    }

    return maps;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Country>>(
      future: _countriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading SVG: ${snapshot.error}'),
          );
        } else {
          final List<Country>? countries = snapshot.data;

          if (countries == null || countries.isEmpty) {
            return const Center(
              child: Text('No countries found.'),
            );
          }

          return InteractiveViewer(
            scaleEnabled: false,
            child: Stack(
              children: [
                for (var country in countries)
                  _getClippedImage(
                    clipper: Clipper(svgPath: country.path),
                    color: Color(int.parse('FF${country.color}', radix: 16))
                        .withOpacity(1.0),
                    country: country,
                    onCountrySelected: (selectedCountry) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ClimaScreen(cityName: selectedCountry.name, color: selectedCountry.color),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        }
      },
    );
  }

  void _handleCountrySelection(Country? country) {}

  Widget _getClippedImage({
    required Clipper clipper,
    required Color color,
    required Country country,
    final Function(Country country)? onCountrySelected,
  }) {
    // Lista de IDs de países que no deben ser seleccionables
    final List<String> nonSelectableCountryIds = [
      'bg'
    ]; // Agrega aquí los IDs no seleccionables

    // Verificar si el ID del país actual está en la lista de IDs no seleccionables
    bool isSelectable = !nonSelectableCountryIds.contains(country.id);

    return ClipPath(
      clipper: clipper,
      child: GestureDetector(
        onTap: isSelectable ? () => onCountrySelected?.call(country) : null,
        child: Stack(
          children: [
            Container(
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

class Clipper extends CustomClipper<Path> {
  Clipper({required this.svgPath});

  final String svgPath;

  @override
  Path getClip(Size size) {
    final Path path = parseSvgPathData(svgPath);

    // Calcular el factor de escala basado en el lado más corto del contenedor
    final double scaleFactor = size.shortestSide / 800.0;

    // Crear una matriz de transformación para aplicar la escala
    final Matrix4 matrix = Matrix4.identity()
      ..scale(scaleFactor); // Aplicar la escala uniformemente
    // Transformar el path con la matriz de escala
    return path.transform(matrix.storage).shift(Offset(-125, 0));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
