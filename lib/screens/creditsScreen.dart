import 'package:flutter/material.dart';

// Clase que representa a una persona con nombre, número de identificación y una imagen asociada
class Person {
  final String name;
  final String carnet;
  final String imageUrl; // URL o ruta de la imagen asociada

  Person(this.name, this.carnet, this.imageUrl);
}

class CreditsScreen extends StatelessWidget {
  CreditsScreen({Key? key}) : super(key: key);

  // Lista de personas con nombres, números de identificación y URLs de imágenes
  final List<Person> people = [
    Person('Luis Antonio Monterroso', '202031794', 'luis.png'),
    Person('Carlos Pac', '201931012', 'carlos.png'),
    Person('Fernando Rodríguez', '202030542', 'fernando.png'),
    Person('Karla Matias', '201830032', 'karla.png'),
    Person('Michelle Cifuentes', '201130968', 'michelle.png'),
    // Agrega más personas según sea necesario
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo con imagen de logo Usac con opacidad y margen
          Container(
            padding: EdgeInsets.all(20.0),
            child: Positioned.fill(
              child: Opacity(
                opacity: 0.07, // Opacidad del logo
                child: Image.asset(
                  "ing.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Contenedor para mostrar la lista de personas en el centro
          Center(
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 5.0), // Margen horizontal
              padding: const EdgeInsets.all(60.0),
              constraints: const BoxConstraints(maxWidth: 400.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Lista de personas
                  Expanded(
                    child: ListView.builder(
                      itemCount: people.length,
                      itemBuilder: (BuildContext context, int index) {
                        final person = people[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(person.imageUrl),
                          ),
                          title: Text(person.name),
                          subtitle: Text('Carnet: ${person.carnet}'),
                          // Agrega más detalles de la persona aquí según sea necesario
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
