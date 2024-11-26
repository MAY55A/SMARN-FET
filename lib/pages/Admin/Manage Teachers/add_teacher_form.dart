import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/services/subject_service.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/models/subject.dart';

class AddTeacherForm extends StatefulWidget {
  final Future<void> Function() refreshTeachers;

  const AddTeacherForm({super.key, required this.refreshTeachers});

  @override
  _AddTeacherFormState createState() => _AddTeacherFormState();
}

class _AddTeacherFormState extends State<AddTeacherForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nbHoursController = TextEditingController();

  List<Subject> _subjectsList = [];
  final List<String> _selectedSubjects = [];

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _nbHoursController.dispose();
    super.dispose();
  }

  // Fetch all subjects from the database
  Future<void> _fetchSubjects() async {
    try {
      List<Subject> subjects = await SubjectService().getAllSubjects();
      setState(() {
        _subjectsList = subjects;
      });
    } catch (e) {
      print("Error fetching subjects: $e");
    }
  }

  Future<void> _addTeacher() async {
    if (_formKey.currentState!.validate()) {
      Teacher newTeacher = Teacher(
        id: '',
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        nbHours: int.tryParse(_nbHoursController.text) ?? 0,
        subjects: _selectedSubjects,
      );

      try {
        await TeacherService().createTeacher(
          _emailController.text,
          _passwordController.text,
          newTeacher,
        );
        await widget.refreshTeachers();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Teacher created successfully!'),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } catch (e) {
        print("Error creating teacher account: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error creating teacher. Please try again.'),
              backgroundColor: Colors.red),
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
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                    labelText: "Phone",
                    labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white)),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
              ),
              TextFormField(
                controller: _nbHoursController,
                decoration: const InputDecoration(
                    labelText: "Number of Hours",
                    labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text("Select Subjects",
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: "Subjects",
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                value: null,
                items: _subjectsList.map((subject) {
                  return DropdownMenuItem<String>(
                    value: subject.id,
                    child: Text(subject.name,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0))),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null && !_selectedSubjects.contains(value)) {
                    setState(() {
                      _selectedSubjects.add(value);
                    });
                  }
                },
              ),
              Wrap(
                children: _selectedSubjects.map((subjectId) {
                  final subject = _subjectsList
                      .firstWhere((subject) => subject.id == subjectId);
                  return Chip(
                    label: Text(subject.name,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0))),
                    onDeleted: () {
                      setState(() {
                        _selectedSubjects.remove(subjectId);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(AppColors.appBarColor),
                ),
                onPressed: _addTeacher,
                child: const Text(
                  "Add Teacher",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
