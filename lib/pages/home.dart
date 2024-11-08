import 'package:flutter/material.dart';
import 'package:smarn/pages/SelectionPage.dart';
import 'package:smarn/pages/Admin/admin_dashboard.dart'; // Import AdminDashboard page
import 'package:smarn/pages/Teacher/teacher_dashboard.dart'; // Import TeacherDashboard page
import 'package:smarn/services/auth_service.dart'; // Import AuthService
import 'package:firebase_auth/firebase_auth.dart'; // Firebase for user management

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isAdmin = false;
  bool _isTeacher = false; // Track if the user is a teacher
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    // Get the current user
    User? user = AuthService().getCurrentUser();
    if (user != null) {
      bool isAdmin = await AuthService().isAdmin(user);
      bool isTeacher = await AuthService().isTeacher(user); // Check if the user is a teacher
      setState(() {
        _isAdmin = isAdmin;
        _isTeacher = isTeacher;
        _currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2), // Light grey background
      appBar: AppBar(
        title: const Text(
          'Smarn',
          style: TextStyle(
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
          // Conditional Button at the bottom of the image
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
              // Change the button based on admin or teacher status
              onPressed: _isAdmin
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminDashboard(),
                        ),
                      );
                    }
                  : _isTeacher
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TeacherDashboard(),
                            ),
                          );
                        }
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectionPage(),
                            ),
                          );
                        },
              child: Text(
                _isAdmin
                    ? 'Admin Dashboard'
                    : _isTeacher
                        ? 'Teacher Dashboard'
                        : 'Login',
                style: const TextStyle(
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
