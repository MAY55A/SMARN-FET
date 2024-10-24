import 'package:flutter/material.dart';
import 'package:smarn/student_form.dart';
import 'package:smarn/Educator_form.dart'; // Import the AdminForm widget

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 9, 17), // Dark background
      appBar: AppBar(
        title: const Text('Smarn'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139), // Blue AppBar
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/img/i66.jpg', // Your background image
              fit: BoxFit.cover, // Ensure the image covers the entire container
            ),
          ),
          // Dark overlay for contrast
          Container(
            color: Colors.black.withOpacity(0.5), // Dark overlay for contrast
          ),
          // Main content
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Login as:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Student Button
                          _buildButton(
                            context,
                            icon: Icons.school,
                            label: ' Student ',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const StudentForm()),
                              );
                            },
                          ),
                          const SizedBox(width: 30), // Space between buttons
                          // Educator Button
                          _buildButton(
                            context,
                            icon: Icons.people,
                            label: 'Educator',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AdminForm()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue, // Text color
                        ),
                        child: const Text(
                          'Refer to the home page',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 235, 249, 255), // Button background
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            Icon(icon, size: 50, color: const Color(0xFF015587)), // Icon color
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF023E8A), // Darker text for contrast
              ),
            ),
          ],
        ),
      ),
    );
  }
}
