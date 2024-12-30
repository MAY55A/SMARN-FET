import 'package:flutter/material.dart';
import 'manage_timetable_teacher.dart';
import 'manage_timetable_class.dart';

class ManageTimetable extends StatelessWidget {
  const ManageTimetable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 0, 0, 0), // Dark background (same as AdminDashboard)
      appBar: AppBar(
        title: const Text('Manage Timetable'),
        backgroundColor: const Color.fromARGB(
            255, 129, 77, 139), // Maintain original app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 129, 77, 139), // Maintain original button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageTimetableTeacher(),
                    ),
                  );
                },
                child: const Text(
                  'Manage Timetable (Teacher)',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 129, 77, 139), // Maintain original button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageTimetableClass(),
                    ),
                  );
                },
                child: const Text(
                  'Manage Timetable (Class)',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
