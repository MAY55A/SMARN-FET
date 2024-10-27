import 'package:flutter/material.dart';
import 'package:smarn/pages/SelectionPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2), // Light grey background
      appBar: AppBar(
        title: const  Text(
          'Smarn',
          style: const TextStyle( // Use default font
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139), // AppBar color
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/img/i6.jpg', // Background image
              fit: BoxFit.cover,
            ),
          ),
          // Overlay text describing the app
          const Positioned(
            bottom: 180, // Position text above the button
            left: 30,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Smarn',
                  style: TextStyle(
                    fontSize: 36, // Increased font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Automate your timetable generation easily with Smarn,',
                  style: TextStyle(
                    fontSize: 20, // Increased font size
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'the administrative app that makes scheduling a breeze!',
                  style: TextStyle(
                    fontSize: 20, // Increased font size
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Login Button at the bottom of the image
          Positioned(
            bottom: 140, // Position the button closer to the bottom
            right: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 30), // Adjust padding
                backgroundColor:
                    const Color.fromARGB(255, 59, 130, 189), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Modern rounded button
                ),
                elevation: 5, // Shadow effect
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectionPage(),
                  ),
                );
              },
              child: const Text(
                'Login',
                style: TextStyle( // Use default font
                  fontSize: 24, // Font size
                  color: Colors.white, // Text color
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
