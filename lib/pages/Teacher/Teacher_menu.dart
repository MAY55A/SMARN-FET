import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/pages/Teacher/Manage%20Info/manage_personnel_information_form.dart';
import 'package:smarn/services/auth_service.dart';

class TeacherDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Fetch the teacher data using TeacherService
    return FutureBuilder<Teacher?>(
      future: TeacherService().fetchTeacherData(), // Fetch teacher data asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show a loading indicator
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text('Error fetching teacher data'));
        }

        Teacher teacher = snapshot.data!;

        return Drawer(
          child: Container(
            color: Colors.grey[800],
            child: ListView(
              children: [
                // Profile Section
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 70, 172, 255), // Set top section background color to pink
                  ),
                  child: SingleChildScrollView( 
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30, 
                          backgroundImage:  AssetImage(
                        '${teacher.picture}',),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          teacher.name,
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          teacher.email!,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 20), 
                      ],
                    ),
                  ),
                ),
                // Personal Info Button
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text(
                    'Personal Info',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManagePersonnelInformationForm(),
                      ),
                    );
                  },
                ),
                // Logout Button
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  tileColor: Colors.blue, // Set bottom section background color to blue
                  onTap: () async {
                    await AuthService().signOut();
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
