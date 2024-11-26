import 'package:flutter/material.dart';
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
        Navigator.pushReplacementNamed(context, '/class_dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Incorrect Class or Key. Please check your inputs."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 9, 17), // Dark background
      appBar: AppBar(
        title: const Text('Student Form'),
        backgroundColor:
            const Color.fromARGB(255, 129, 77, 139), // Purple theme
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color:
                  const Color.fromARGB(255, 43, 43, 43), // Form container color
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 58, 58, 58).withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400, // Center and limit width for responsiveness
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Student Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text for title
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Class Input Field
                    TextFormField(
                      controller: _classController,
                      style: const TextStyle(
                          color: Colors.white), // White text inside field
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Class',
                        labelStyle:
                            TextStyle(color: Colors.white), // White label
                        fillColor: Color.fromARGB(
                            255, 58, 58, 58), // Darker field background
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
                    // Key Input Field
                    TextFormField(
                      controller: _keyController,
                      style: const TextStyle(
                          color: Colors.white), // White text inside field
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Key to Connect',
                        labelStyle:
                            TextStyle(color: Colors.white), // White label
                        fillColor: Color.fromARGB(
                            255, 58, 58, 58), // Darker field background
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
                    // Submit Button
                    ElevatedButton(
                      onPressed: _accessClassSchedule,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(
                              255, 129, 77, 139), // Purple button color
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 15.0),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white, // White text on button
                          fontWeight: FontWeight.bold,
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
