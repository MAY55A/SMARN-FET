import 'package:flutter/material.dart';
import 'package:smarn/CRUD_test.dart';
import 'package:smarn/pages/teacher_dashboard.dart';
import 'package:smarn/services/auth_service.dart';
import 'package:smarn/services/teacher_service.dart';

class EducatorForm extends StatefulWidget {
  const EducatorForm({super.key});

  @override
  _EducatorFormState createState() => _EducatorFormState();
}

class _EducatorFormState extends State<EducatorForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final TeacherService _teacherService = TeacherService();
  final AuthService _auth = AuthService();

  Future<void> _loginTeacher() async {
    if (_formKey.currentState!.validate()) {
      try {
        var res = await _teacherService.login(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );
        if (res['success']) {
          //getTeacher(_auth.getCurrentUser()!.uid);
          //updateTeacher(_auth.getCurrentUser()!.uid);
          //requestCrud();
          Navigator.pushReplacementNamed(context, '/teacher_dashboard');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'])),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 0, 9, 17), // Light grey background
      appBar: AppBar(
        title: const Text('Educator Form'),
        backgroundColor:
            const Color.fromARGB(255, 129, 77, 139), // AppBar color blue
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 236, 248, 253),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400, // Match the width of StudentForm
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Text color blue
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _loginTeacher,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color blue
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Color.fromARGB(
                              255, 255, 255, 255), // Button text color white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
