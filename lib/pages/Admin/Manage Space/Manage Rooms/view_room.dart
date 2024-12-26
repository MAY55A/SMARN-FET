import 'package:flutter/material.dart';
import 'package:smarn/models/room.dart';

class ViewRoom extends StatelessWidget {
  final Room roomItem;

  const ViewRoom({super.key, required this.roomItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        title: const Text('Room Details'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 600, // Fixed width to make it bigger
          height: 300, // Set a fixed height to make the card larger
          child: Card(
            color: const Color.fromARGB(255, 34, 34, 34), // Dark card color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // Rounded corners for the card
            ),
            elevation: 5.0, // Slight shadow for the card
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView( // Allow scrolling if content overflows
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room Name: ${roomItem.name}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Description: ${roomItem.description}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Capacity: ${roomItem.capacity}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Building: ${roomItem.building}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Room Type: ${roomItem.type.name}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
