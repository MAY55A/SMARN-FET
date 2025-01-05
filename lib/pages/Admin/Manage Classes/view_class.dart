import 'package:flutter/material.dart';
import 'package:smarn/models/class.dart';

class ViewClass extends StatelessWidget {
  final Class classItem;

  const ViewClass({Key? key, required this.classItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fond noir
      appBar: AppBar(
        title: Text(classItem.name),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.grey[850], // Couleur de la carte
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(32.0), // Augmentation de l'espacement interne
              child: Column(
                mainAxisSize: MainAxisSize.min, // Pour que la carte prenne seulement l'espace nécessaire
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Class Name: ${classItem.name}',
                    style: const TextStyle(color: Colors.white, fontSize: 24), // Augmentation de la taille du texte
                  ),
                  const SizedBox(height: 16), // Augmentation de l'espacement
                  Text(
                    'Long Name: ${classItem.longName}',
                    style: const TextStyle(color: Colors.white, fontSize: 24), // Augmentation de la taille du texte
                  ),
                  const SizedBox(height: 16), // Augmentation de l'espacement
                  Text(
                    'Number of Students: ${classItem.nbStudents}',
                    style: const TextStyle(color: Colors.white, fontSize: 24), // Augmentation de la taille du texte
                  ),
                  const SizedBox(height: 16), // Augmentation de l'espacement
                  Text(
                    'Access Key: ${classItem.accessKey ?? "N/A"}',
                    style: const TextStyle(color: Colors.white, fontSize: 24), // Augmentation de la taille du texte
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
