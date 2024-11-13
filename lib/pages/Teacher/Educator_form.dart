import 'package:flutter/material.dart';
import 'package:smarn/pages/Teacher/teacher_dashboard.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/teacher_service.dart';

class EducatorForm extends StatefulWidget {
  final Function onLoginSuccess; // Callback for login success

  const EducatorForm({super.key, required this.onLoginSuccess});

  @override
  _EducatorFormState createState() => _EducatorFormState();
}

class _EducatorFormState extends State<EducatorForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final TeacherService _teacherService = TeacherService();

  Future<void> _loginTeacher() async {
    if (_formKey.currentState!.validate()) {
      try {
        bool success = await _teacherService.login(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );
        if (success) {
          widget.onLoginSuccess(); // Trigger the callback
          Navigator.pushReplacementNamed(context, '/teacher_dashboard');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Login failed. Please check your credentials.")),
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
      backgroundColor: const Color.fromARGB(255, 0, 9, 17),
      appBar: AppBar(
        title: const Text('Educator Form'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView( // Wrap the entire form in a SingleChildScrollView
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.formColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 106, 106, 106).withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
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
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
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
                          labelStyle: TextStyle(color: Colors.white),
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
                          backgroundColor: AppColors.appBarColor,
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
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
      ),
    );
  }
}
