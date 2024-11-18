import 'package:flutter/material.dart';
import 'package:smarn/pages/Student/class_dashboard.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/class_service.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({super.key});

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final ClassService _classService = ClassService();

  Future<void> _accessClassSchedule() async {
    if (_formKey.currentState!.validate()) {
      var studentsClass = await _classService.getclassDetails(
        _classController.text.trim(),
        _keyController.text.trim(),
      );
      if (studentsClass != null) {
        print(studentsClass);
        Navigator.pushReplacementNamed(context, '/class_dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Class not found. Please check your inputs.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Dark background
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor, // AppBar color
        title: const Text('Student Form'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.formColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 66, 66, 66).withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400, // Limits the form width for larger screens
                ),
                child: ListView(
                  shrinkWrap: true, // Makes the ListView fit its content
                  children: [
                    const Text(
                      'Student Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Class Field
                    TextFormField(
                      controller: _classController,
                      decoration: const InputDecoration(
                        labelText: 'Class',
                        labelStyle: TextStyle(color:Colors.white),                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the class';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Key Field
                    TextFormField(
                      controller: _keyController,
                      decoration: const InputDecoration(
                        labelText: 'Key to Connect',
                        labelStyle: TextStyle(color:Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the key to connect';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _accessClassSchedule,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 5), // Less vertical padding
                        backgroundColor: const Color.fromARGB(255, 129, 77, 139), // Button color
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 12, // Smaller font size
                          color: Color.fromARGB(
                              255, 255, 236, 249), // Text color set to white
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
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
