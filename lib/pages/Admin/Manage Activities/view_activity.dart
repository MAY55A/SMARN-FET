import 'package:flutter/material.dart';

class ViewActivity extends StatelessWidget {
  final Map<String, dynamic> activity;

  const ViewActivity({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fond noir
      appBar: AppBar(
        title: const Text("Activity Details"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.grey[850], // Couleur de la carte
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Pour que la carte prenne seulement l'espace nécessaire
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Subject: ${activity['subject']['longName']}",
                      style: const TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 8),
                  Text("Class: ${activity['studentsClass']['name']}",
                      style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Teacher: ${activity['teacher']['name']}",
                      style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Duration: ${activity['duration']} minutes",
                      style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Tag: ${activity['tag']}",
                      style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 8),
                  if (activity['room'] != null)
                    Text("Room: ${activity['room']}",
                        style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Active: ${activity['isActive'] ? 'Yes' : 'No'}",
                      style: const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
