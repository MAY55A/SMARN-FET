import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/teacher_service.dart';

class EditTeacherForm extends StatefulWidget {
  final Teacher teacher;
  final Future<void> Function() refreshTeachers;

  const EditTeacherForm({Key? key, required this.teacher, required this.refreshTeachers}) : super(key: key);

  @override
  _EditTeacherFormState createState() => _EditTeacherFormState();
}

class _EditTeacherFormState extends State<EditTeacherForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.teacher.name);
    _emailController = TextEditingController(text: widget.teacher.email);
    _phoneController = TextEditingController(text: widget.teacher.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _editTeacher() async {
    if (_formKey.currentState!.validate()) {
      Teacher updatedTeacher = Teacher(
        id: widget.teacher.id, // Retain the teacher's ID
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        nbHours: widget.teacher.nbHours, // Preserve original nbHours
        subjects: widget.teacher.subjects,
        activities: widget.teacher.activities,
      );

      try {
        await TeacherService().updateTeacher(updatedTeacher); // Call update method
        widget.refreshTeachers(); // Refresh the list after update
        Navigator.pop(context); // Close the form
      } catch (e) {
        print("Error updating teacher: $e");
        // Optionally show an error message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        title: const Text("Edit Teacher"),
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Name field
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white), // Text color
                  decoration: const InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.white), // Label color
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Focus border color
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email field
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white), // Text color
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white), // Label color
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Focus border color
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Phone field
                TextFormField(
                  controller: _phoneController,
                  style: const TextStyle(color: Colors.white), // Text color
                  decoration: const InputDecoration(
                    labelText: "Phone",
                    labelStyle: TextStyle(color: Colors.white), // Label color
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Focus border color
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AppColors.appBarColor),
                    foregroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  onPressed: _editTeacher,
                  child: const Text("Save Changes"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
