import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/teacher_service.dart';

class AddTeacherForm extends StatefulWidget {
  final Future<void> Function() refreshTeachers;

  const AddTeacherForm({Key? key, required this.refreshTeachers}) : super(key: key);

  @override
  _AddTeacherFormState createState() => _AddTeacherFormState();
}

class _AddTeacherFormState extends State<AddTeacherForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _addTeacher() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;

      // Check if email is empty after validation
      if (email.isEmpty) {
        print("Email should not be empty.");
        return;
      }

      Teacher newTeacher = Teacher(
        id: '', // ID will be generated automatically in the service
        name: _nameController.text,
        email: email, // Assign the email safely
        phone: _phoneController.text,
        nbHours: 0,  // Default value, adjust as needed
        subjects: [],  // No subjects for now
        activities: [],  // No activities for now
      );

      try {
        await TeacherService().createTeacherAccount(
          newTeacher.email!, // Assuming email is valid
          'defaultPassword', // Handle password securely
          newTeacher,
        );

        await widget.refreshTeachers();  // Refresh the teacher list after adding
        Navigator.pop(context);  // Close the form
      } catch (e) {
        print("Error adding teacher: $e");
        // Optionally show an error message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        title: const Text("Add Teacher"),
      ),
      body: Padding(
        
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the name";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone (optional)"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addTeacher,
                child: const Text("Add Teacher"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
