// ignore: file_names
class Lectura {
  final String fechahora;
  final double temperatura;
  final double humedad;
  final double radiacion;
  final double suelo1;
  final double suelo2;
  final double suelo3;
  final double direccion;
  final double velocidad;
  final double precipitacion;

  Lectura({
    required this.fechahora,
    required this.temperatura,
    required this.humedad,
    required this.radiacion,
    required this.suelo1,
    required this.suelo2,
    required this.suelo3,
    required this.direccion,
    required this.velocidad,
    required this.precipitacion,
  });

  factory Lectura.fromJson(Map<String, dynamic> json) {
    return Lectura(
      fechahora: json['fechahora'],
      temperatura: double.parse(json['temperatura']),
      humedad: double.parse(json['humedad']),
      radiacion: double.parse(json['radiacion']),
      suelo1: double.parse(json['suelo1']),
      suelo2: double.parse(json['suelo2']),
      suelo3: double.parse(json['suelo3']),
      direccion: double.parse(json['direccion']),
      velocidad: double.parse(json['velocidad']),
      precipitacion: double.parse(json['precipitacion']),
    );
  }
}
