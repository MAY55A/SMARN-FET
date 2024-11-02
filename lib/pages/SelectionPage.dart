import 'package:flutter/material.dart';
import 'package:smarn/pages/admin_form.dart';
import 'package:smarn/pages/student_form.dart';
import 'package:smarn/pages/Educator_form.dart'; // Import the AdminForm widget

class SelectionPage extends StatefulWidget {
  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  bool _isButtonVisible = false;

  void _revealButton() {
    setState(() {
      _isButtonVisible = true; // Show the admin login form
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 9, 17), // Dark background
      appBar: AppBar(
        title: const Text('Smarn'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139), // Blue AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login as:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(
                    221, 8, 5, 17), // Darker text color for contrast
              ),
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 12),
                // Pupil Button
                _buildButton(
                  context,
                  icon: Icons.school,
                  label: '  Student ',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StudentForm()),
                    );
                  },
                ),
                const SizedBox(width: 40), // Space between buttons
                // Admin Button
                _buildButton(
                  context,
                  icon: Icons.people,
                  label: 'Educator',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  AdminForm()),
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
              child: const Text('Refer to the home page'),
            ),
          ],
        ),
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
