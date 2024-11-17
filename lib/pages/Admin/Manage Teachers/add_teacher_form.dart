import 'package:flutter/material.dart';
import 'package:smarn/models/activity.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/pages/widgets/canstants.dart';
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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nbHoursController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();

  List<Subject> _subjects = [];
  List<Activity> _activities = [];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _nbHoursController.dispose();
    _subjectController.dispose();
    _activityController.dispose();
    super.dispose();
  }

  Future<void> _addTeacher() async {
    if (_formKey.currentState!.validate()) {
      Teacher newTeacher = Teacher(
        id: '',
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        nbHours: int.tryParse(_nbHoursController.text) ?? 0,
        subjects: _subjects,
        activities: _activities,
      );

      try {
        await TeacherService().createTeacherAccount(
          _emailController.text,
          _passwordController.text,
          newTeacher,
        );
        await widget.refreshTeachers();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teacher created successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } catch (e) {
        print("Error creating teacher account: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error creating teacher. Please try again.'), backgroundColor: Colors.red),
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
                decoration: const InputDecoration(labelText: "Name", labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone", labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password", labelStyle: TextStyle(color: Colors.white)),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
              ),
              TextFormField(
                controller: _nbHoursController,
                decoration: const InputDecoration(labelText: "Number of Hours", labelStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: "Subjects", labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                onFieldSubmitted: (value) {
                  setState(() {
                    _subjects.add(value as Subject);
                    _subjectController.clear();
                  });
                },
              ),
              Wrap(
                children: _subjects.map((subject) {
                  return Chip(
                    label: Text(subject as String, style: const TextStyle(color: Colors.white)),
                    onDeleted: () {
                      setState(() {
                        _subjects.remove(subject);
                      });
                    },
                  );
                }).toList(),
              ),
              TextFormField(
                controller: _activityController,
                decoration: const InputDecoration(labelText: "Activities", labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                onFieldSubmitted: (value) {
                  setState(() {
                    _activities.add(value as Activity);
                    _activityController.clear();
                  });
                },
              ),
              Wrap(
                children: _activities.map((activity) {
                  return Chip(
                    label: Text(activity as String, style: const TextStyle(color: Colors.white)),
                    onDeleted: () {
                      setState(() {
                        _activities.remove(activity);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.appBarColor),
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
