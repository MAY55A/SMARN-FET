import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smarn/pages/Educator_form.dart';
import 'package:smarn/pages/admin_dashboard.dart';
import 'package:smarn/pages/admin_form.dart';
import 'package:smarn/pages/home.dart';
import 'package:smarn/firebase_options.dart';
import 'package:smarn/pages/class_dashboard.dart';
import 'package:smarn/pages/student_form.dart';
import 'package:smarn/pages/teacher_dashboard.dart';

//Firebase configuration
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMARN',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Choose one home screen to display
      initialRoute: '/',
      routes: {
        '/': (context) =>
            HomePage(), // Home screen (choose admin, teacher, or student)
        '/admin_login': (context) => AdminForm(), // Admin login form
        '/class_access': (context) =>
            StudentForm(), // Student class access form
        '/teacher_login': (context) => EducatorForm(), // Teacher login form
        '/admin_dashboard': (context) => AdminDashboard(), // Admin dashboard
        '/class_dashboard': (context) =>
            ClassDashboard(), // Class schedule screen
        '/teacher_dashboard': (context) =>
            TeacherDashboard(), // Teacher dashboard
      },
    );
  }
}
