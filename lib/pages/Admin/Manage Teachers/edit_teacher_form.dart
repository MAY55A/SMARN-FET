import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/services/subject_service.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class EditTeacherForm extends StatefulWidget {
  final VoidCallback refreshTeachers;
  final Teacher teacher;

  const EditTeacherForm({
    Key? key,
    required this.refreshTeachers,
    required this.teacher,
  }) : super(key: key);

  @override
  _EditTeacherFormState createState() => _EditTeacherFormState();
}

class _EditTeacherFormState extends State<EditTeacherForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _nbHoursController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true; // To toggle password visibility
  List<Subject> allSubjects = [];
  List<Subject> selectedSubjects = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.teacher.name);
    _emailController = TextEditingController(text: widget.teacher.email);
    _phoneController = TextEditingController(text: widget.teacher.phone);
    _nbHoursController = TextEditingController(text: widget.teacher.nbHours.toString());
    _passwordController = TextEditingController();

    _fetchAllSubjects();
  }

  // Fetch all subjects from the database
  Future<void> _fetchAllSubjects() async {
    List<Subject> subjects = await SubjectService().getAllSubjects();
    setState(() {
      allSubjects = subjects;
      _loadTeacherSubjects();
    });
  }

  // Load teacher's assigned subjects into selectedSubjects list
  void _loadTeacherSubjects() {
    selectedSubjects = allSubjects.where((subject) {
      return widget.teacher.subjects!.contains(subject.name);
    }).toList();
  }

  // Update the teacher
  Future<void> _updateTeacher() async {
    if (_formKey.currentState!.validate()) {
      try {
        Teacher updatedTeacher = Teacher(
          id: widget.teacher.id,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          nbHours: int.parse(_nbHoursController.text.trim()),
          subjects: [], //empty
        );

        final response = await TeacherService().updateTeacher(
          widget.teacher.id!,
          updatedTeacher,
        );

        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Teacher updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          widget.refreshTeachers();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Failed to update teacher.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating teacher: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Cancel and go back
  void _cancelUpdates() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        title: const Text(
          "Edit Teacher",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Name is required.";
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Email is required.";
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Enter a valid email address.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Phone is required.";
                  if (value.length != 8 || !RegExp(r'^\d+$').hasMatch(value)) {
                    return "Phone number must be 8 digits.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nbHoursController,
                decoration: const InputDecoration(
                  labelText: "Number of Hours",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Number of hours is required.";
                  if (int.tryParse(value)! <= 0) return "Hours must be greater than 0.";
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (value.length < 6) return "Password must be at least 6 characters.";
                    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                      return "Password must include upper, lower case, and a number.";
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColors.appBarColor),
                    ),
                    onPressed: _updateTeacher,
                    child: const Text(
                      "Update Teacher",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                    ),
                    onPressed: _cancelUpdates,
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
