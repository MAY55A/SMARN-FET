import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/services/subject_service.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class EditTeacherForm extends StatefulWidget {
  final VoidCallback refreshTeachers;
  final Teacher teacher; // Teacher object to pass the teacher data

  const EditTeacherForm({
    Key? key,
    required this.refreshTeachers,
    required this.teacher, // Add the teacher data here
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
  List<Subject> allSubjects = []; // All subjects from database
  List<Subject> selectedSubjects = []; // Subjects selected for the teacher

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.teacher.name);
    _emailController = TextEditingController(text: widget.teacher.email);
    _phoneController = TextEditingController(text: widget.teacher.phone);
    _nbHoursController = TextEditingController(text: widget.teacher.nbHours.toString());
    _passwordController = TextEditingController();

    _fetchAllSubjects();
    _loadTeacherSubjects();
  }

  // Fetch all subjects from the database
  Future<void> _fetchAllSubjects() async {
    List<Subject> subjects = await SubjectService().getAllSubjects();
    setState(() {
      allSubjects = subjects;
    });
  }

  // Load teacher's assigned subjects into selectedSubjects list
  void _loadTeacherSubjects() {
    setState(() {
      selectedSubjects = allSubjects.where((subject) {
        return widget.teacher.subjects!.contains(subject.name);
      }).toList();
    });
  }

  // Method to remove subject
  void _removeSubject(Subject subject) {
    setState(() {
      selectedSubjects.remove(subject);
    });
  }

  // Method to add subject
  void _addSubject(Subject subject) {
    setState(() {
      if (!selectedSubjects.contains(subject)) {
        selectedSubjects.add(subject);
      }
    });
  }

  // Method to save the updated teacher
  Future<void> _editTeacher() async {
    if (_formKey.currentState!.validate()) {
      Teacher updatedTeacher = Teacher(
        id: widget.teacher.id, // Preserving the teacher's id for update
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        nbHours: int.tryParse(_nbHoursController.text) ?? 0,
        subjects: selectedSubjects.map((e) => e.name).toList(),
      );

      // Call the update function (replace with actual service)
      // Example: TeacherService().updateTeacher(updatedTeacher);

      widget.refreshTeachers(); // Refresh teacher list after updating
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        title: const Text(
          "Edit Teacher",
          style: TextStyle(color: Colors.white), // White text color in app bar
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
                  labelStyle: TextStyle(color: Colors.white), // White label text
                ),
                style: const TextStyle(color: Colors.white), // White text in input
                validator: (value) => value!.isEmpty ? "Name cannot be empty" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white), // White label text
                ),
                style: const TextStyle(color: Colors.white), // White text in input
                validator: (value) =>
                    value!.isEmpty ? "Email cannot be empty" : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  labelStyle: TextStyle(color: Colors.white), // White label text
                ),
                style: const TextStyle(color: Colors.white), // White text in input
                validator: (value) =>
                    value!.isEmpty ? "Phone cannot be empty" : null,
              ),
              TextFormField(
                controller: _nbHoursController,
                decoration: const InputDecoration(
                  labelText: "Number of Hours",
                  labelStyle: TextStyle(color: Colors.white), // White label text
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white), // White text in input
                validator: (value) =>
                    value!.isEmpty ? "Hours cannot be empty" : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password (Optional)",
                  labelStyle: TextStyle(color: Colors.white), // White label text
                ),
                style: const TextStyle(color: Colors.white), // White text in input
                obscureText: true,
              ),
              const SizedBox(height: 20),
              const Text(
                "Subjects",
                style: TextStyle(color: Colors.white), // White text for section title
              ),
              // Display all subjects with the option to select
              if (allSubjects.isNotEmpty)
                Wrap(
                  children: allSubjects.map((subject) {
                    return ChoiceChip(
                      label: Text(subject.name, style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))), // White text for chip
                      selected: selectedSubjects.contains(subject),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _addSubject(subject);
                          } else {
                            _removeSubject(subject);
                          }
                        });
                      },
                      selectedColor: Colors.purple, // Selected chip color
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.appBarColor),
                ),
                onPressed: _editTeacher,
                child: const Text(
                  "Update Teacher",
                  style: TextStyle(color: Colors.white), // White text on button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
