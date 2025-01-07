import 'package:flutter/material.dart';
import 'package:smarn/pages/Student/view_timetable.dart';
import 'package:smarn/services/class_service.dart';
import 'package:smarn/pages/widgets/canstants.dart'; // Assuming AppColors is defined here

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
      try {
        var studentsClass = await _classService.getClassDetails(
          _classController.text.trim(),
          _keyController.text.trim(),
        );
        if (studentsClass != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewTimetable(studentsClass: studentsClass,)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("Incorrect Class or Key. Please check your inputs."),
            ),
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
      backgroundColor: const Color.fromARGB(255, 0, 9, 17), // Dark background
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor, // AppBar color
        title: const Text('Student Form'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.formColor, // Form background
              borderRadius: BorderRadius.circular(10),
              // Removed shadow effect here
            ),
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400, // Match width of EducatorForm
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Access Class Schedule',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Title text color
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Class Field
                    TextFormField(
                      controller: _classController,
                      style: const TextStyle(
                          color: Colors.white), // Text color inside field
                      decoration: const InputDecoration(
                        labelText: 'Class',
                        border: OutlineInputBorder(),
                        labelStyle:
                            TextStyle(color: Colors.white), // Label text color
                        fillColor:
                            Color.fromARGB(255, 58, 58, 58), // Field background
                        filled: true,
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
                      style: const TextStyle(
                          color: Colors.white), // Text color inside field
                      decoration: const InputDecoration(
                        labelText: 'Key to Connect',
                        border: OutlineInputBorder(),
                        labelStyle:
                            TextStyle(color: Colors.white), // Label text color
                        fillColor:
                            Color.fromARGB(255, 58, 58, 58), // Field background
                        filled: true,
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
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            AppColors.appBarColor), // Button color
                        foregroundColor: MaterialStateProperty.all(
                            Colors.white), // Button text color
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 16),
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
