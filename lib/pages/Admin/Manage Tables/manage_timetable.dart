import 'package:flutter/material.dart';
import 'package:smarn/pages/Admin/Manage%20Tables/manage_timetable_class.dart';
import 'package:smarn/pages/Admin/Manage%20Tables/manage_timetable_teacher.dart';

class ManageTimetable extends StatelessWidget {
  const ManageTimetable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manage Timetable '),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 129, 77, 139), // Couleur de fond du bouton
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Coins arrondis
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
                    255, 129, 77, 139), // Couleur de fond du bouton
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Coins arrondis
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
    );
  }
}
