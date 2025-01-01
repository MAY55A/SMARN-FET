// Dashboard card with 3D effect, shadow, and hover animation
import 'package:flutter/material.dart';
import 'package:smarn/pages/widgets/canstants.dart';

Widget buildAnimatedDashboardCard(
    BuildContext context, String title, IconData icon, Widget page, Color color) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => page)); // Navigate to the specified page
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // Slightly adjusted radius
        color: const Color.fromARGB(255, 84, 84, 84),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 3), // Creates a more subtle shadow
          ),
        ],
      ),
      child: InkWell(
        splashColor: Color.fromARGB(255, 56, 56, 56), // Splash effect
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Adjusted padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 36,
                  color:color), // Further reduced icon size
              const SizedBox(height: 8), // Reduced spacing
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12, // Smaller font size
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(
                      255, 254, 254, 254), // Same as sidebar for uniformity
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
