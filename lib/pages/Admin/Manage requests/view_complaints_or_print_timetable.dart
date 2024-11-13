import 'package:flutter/material.dart';
import 'package:smarn/pages/Teacher/Request/request_form.dart';

class ViewComplaintsOrPrintTimetable extends StatelessWidget {
  const ViewComplaintsOrPrintTimetable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timetable"),
        backgroundColor: const Color.fromARGB(
            255, 129, 77, 139), // Purple to match the image
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color:
            const Color(0xFF2C2C2C), // Dark background color to match the image
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timetable section container
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[900], // Dark grey container
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "This section Contains timetable.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue, // Blue text to match the screenshot
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Row of icon buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Request Button

                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RequestForm()), // Navigate to the RequestForm
                          );
                        },
                        icon: const Icon(
                          Icons.message,
                          color: Colors.blue,
                        ),
                        label: const Text(
                          'Request',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700],
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      // Print Button
                      ElevatedButton.icon(
                        onPressed: () {
                          // Handle print button press
                        },
                        icon: const Icon(
                          Icons.print,
                          color: Colors.blue, // Blue icon
                        ),
                        label: const Text(
                          'Print',
                          style: TextStyle(
                            color: Colors.blue, // Blue text
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.grey[700], // Grey background for button
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
