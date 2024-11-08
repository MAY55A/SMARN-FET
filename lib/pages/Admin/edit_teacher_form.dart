import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
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
        id: widget.teacher.id,  // Retain the teacher's ID
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        nbHours: widget.teacher.nbHours,  // Preserve original nbHours
        subjects: widget.teacher.subjects,
        activities: widget.teacher.activities,
      );

      try {
        await TeacherService().updateTeacher(updatedTeacher);  // Call update method
        widget.refreshTeachers();  // Refresh the list after update
        Navigator.pop(context);  // Close the form
      } catch (e) {
        print("Error updating teacher: $e");
        // Optionally show an error message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 9, 17),
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 129, 77, 139), 
        title: const Text("Edit Teacher"),
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Padding(
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
                  decoration: const InputDecoration(labelText: "Phone"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
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
