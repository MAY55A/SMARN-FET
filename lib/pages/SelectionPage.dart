import 'package:flutter/material.dart';
import 'package:smarn/pages/widgets/canstants.dart'; // Import the AdminForm widget

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

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
          // Main content wrapped in a SingleChildScrollView to avoid overflow
          SingleChildScrollView(
            child: Padding(
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
                          Navigator.pushReplacementNamed(
                              context, '/class_access');
                        },
                      ),
                      const SizedBox(width: 30), // Space between buttons
                      // Educator Button
                      _buildButton(
                        context,
                        icon: Icons.people,
                        label: 'Educator',
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, '/teacher_login');
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
                  // Hidden area for long press detection
                  GestureDetector(
                    onLongPress: _revealButton, // Long press to reveal button
                    child: Container(
                      width: 200, // Set a width for the hidden area
                      height: 200, // Set a height for the hidden area
                      color: Colors
                          .transparent, // Transparent color for invisibility
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_isButtonVisible)
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppColors.appBarColor),
                      ),
                      onPressed: () {
                        // Navigate to Admin Login Form
                        Navigator.pushReplacementNamed(context, '/admin_login');
                      },
                      child: const Text(
                        "Go to Admin Login",
                        style: TextStyle(color: Colors.white),
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

  Widget _buildButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 180, 202, 255), // Button background
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            Icon(icon, size: 50, color: AppColors.appBarColor), // Icon color
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 0, 0, 0), // Darker text for contrast
              ),
            ),
          ],
        ),
      ),
    );
  }
}
