import 'package:flutter/material.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("404 - Page Not Found"),
        backgroundColor: AppColors.appBarColor,
      ),
      body: Container(
        color: AppColors.backgroundColor, // Black background
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 80,
              ),
              SizedBox(height: 20),
              Text(
                "Oops! Page not found.",
                style: TextStyle(
                  color: Colors.white, // White text color
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "The page you're looking for doesn't exist.",
                style: TextStyle(
                  color: Colors.white70, // Lighter white for secondary text
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
