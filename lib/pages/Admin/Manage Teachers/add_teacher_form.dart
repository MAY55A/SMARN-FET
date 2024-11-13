import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/teacher_service.dart';

class AddTeacherForm extends StatefulWidget {
  final Future<void> Function() refreshTeachers;

  const AddTeacherForm({Key? key, required this.refreshTeachers})
      : super(key: key);

  @override
  _AddTeacherFormState createState() => _AddTeacherFormState();
}

class _AddTeacherFormState extends State<AddTeacherForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController(); // Password controller

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _addTeacher() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // Check if email and password are valid
      if (email.isEmpty || password.isEmpty) {
        print("Email and Password should not be empty.");
        return;
      }

      if (password.length < 6) {
        print("Password should be at least 6 characters long.");
        return;
      }

      Teacher newTeacher = Teacher(
        id: '', // ID will be generated automatically in the service
        name: _nameController.text,
        email: email, // Assign the email safely
        phone: _phoneController.text,
        nbHours: 0, // Default value, adjust as needed
        subjects: [], // No subjects for now
        activities: [], // No activities for now
      );

      try {
        // The password field is added here, use it when creating the teacher account
        await TeacherService().createTeacherAccount(
          email, // Using the entered email
          password, // Using the entered password
          newTeacher,
        );

        // Refresh teacher list after adding
        await widget.refreshTeachers(); 

        // Show a success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Teacher created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Close the form after success
        Navigator.pop(context);
      } catch (e) {
        print("Error creating teacher account: $e");

        // Optionally show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error creating teacher. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        title: const Text("Add Teacher"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the name";
                  }
                  return null;
                },
              ),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),

              // Phone Number Field
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a password";
                  }
                  if (value.length < 6) {
                    return "Password should be at least 6 characters long!";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Add Teacher Button
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.appBarColor),
                  foregroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 0, 0, 0)),
                ),
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
