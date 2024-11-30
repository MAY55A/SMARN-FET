import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smarn/pages/SelectionPage.dart';
import 'package:smarn/pages/Admin/admin_dashboard.dart';
import 'package:smarn/pages/Teacher/teacher_dashboard.dart';
import 'package:smarn/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userRole = ''; // Tracks user role (admin, teacher, or empty if none)
  late StreamSubscription<User?> _authSubscription;
  User? _currentUser;

  @override
  void initState() {
    super.initState();

    // Listen for authentication state changes
    _authSubscription = AuthService().authStateChanges.listen((user) {
      _checkUserRole(); // Fetch the user role when logged in
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel(); // Cancel the subscription to avoid memory leaks
    super.dispose();
  }

  Future<void> _checkUserRole() async {
    User? user = AuthService().getCurrentUser();
    String? role = await AuthService().getUserRole(user);
    setState(() {
      _currentUser = user;
      _userRole = role ?? '';
    });
  }

  void _navigateToRolePage() {
    if (_userRole == 'admin') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboard()),
      );
    } else if (_userRole == 'teacher') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TeacherDashboard()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SelectionPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text(
          'Smarn',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/i6.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const Positioned(
            bottom: 180,
            left: 30,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Smarn',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Automate your timetable generation easily with Smarn,',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'the administrative app that makes scheduling a breeze!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height:60)
              ],
            ),
          ),
          Positioned(
            bottom: 140,
            right: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                backgroundColor: const Color.fromARGB(255, 59, 130, 189),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              onPressed: _navigateToRolePage,
              child: Text(
                _userRole == 'admin'
                    ? 'Admin Dashboard'
                    : _userRole == 'teacher'
                        ? 'Teacher Dashboard'
                        : 'Login',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
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
