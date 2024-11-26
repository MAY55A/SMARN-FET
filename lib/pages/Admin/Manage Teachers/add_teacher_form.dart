import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/services/subject_service.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/models/subject.dart';

class AddTeacherForm extends StatefulWidget {
  final Future<void> Function() refreshTeachers;

<<<<<<< HEAD
  const AddTeacherForm({super.key, required this.refreshTeachers});
=======
  const AddTeacherForm({Key? key, required this.refreshTeachers})
      : super(key: key);
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81

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
<<<<<<< HEAD
  final List<String> _selectedSubjects = [];
=======
  List<String> _selectedSubjects = [];
  
  bool _isPasswordVisible = false;
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81

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
      try {
        Teacher newTeacher = Teacher(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          nbHours: int.tryParse(_nbHoursController.text.trim()) ?? 0,
          subjects: [],
        );
        var response = await TeacherService().createTeacher(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          newTeacher,
        );
<<<<<<< HEAD
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
=======

        if (response != null && response['success'] == true) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response['message'] ?? 'Teacher created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response['message'] ?? 'Failed to create teacher.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
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
<<<<<<< HEAD
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.white)),
=======
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.white),
                ),
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
<<<<<<< HEAD
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white)),
=======
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white),
                ),
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
<<<<<<< HEAD
                    labelText: "Phone",
                    labelStyle: TextStyle(color: Colors.white)),
=======
                  labelText: "Phone",
                  labelStyle: TextStyle(color: Colors.white),
                ),
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone is required';
                  }
                  if (value.length != 8 || !RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Phone number must be 8 digits';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
<<<<<<< HEAD
                decoration: const InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white)),
                obscureText: true,
=======
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                    return 'Password must contain upper, lower case letters, and a number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nbHoursController,
                decoration: const InputDecoration(
<<<<<<< HEAD
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
=======
                  labelText: "Number of Hours",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Number of hours is required';
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                  }
                  if (int.tryParse(value)! <= 0) {
                    return 'Number of hours must be greater than 0';
                  }
                  return null;
                },
              ),
<<<<<<< HEAD
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
=======
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.appBarColor),
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
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
