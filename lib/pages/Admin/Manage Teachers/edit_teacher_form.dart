import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/pages/widgets/canstants.dart';


class EditTeacherForm extends StatefulWidget {
  final VoidCallback refreshTeachers;

  const EditTeacherForm({
    Key? key,
    required this.refreshTeachers, required Teacher teacher,
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
  List<Map<String, String>> subjects = [];
  List<Map<String, String>> activities = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _nbHoursController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void _addSubject() {
    setState(() {
      subjects.add({'name': ''});
    });
  }

  void _addActivity() {
    setState(() {
      activities.add({'name': ''});
    });
  }

  void _removeSubject(int index) {
    setState(() {
      subjects.removeAt(index);
    });
  }

  void _removeActivity(int index) {
    setState(() {
      activities.removeAt(index);
    });
  }

  Future<void> _editTeacher() async {
    if (_formKey.currentState!.validate()) {
      // Logic to save updated teacher data goes here
      widget.refreshTeachers();
      Navigator.pop(context);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Name cannot be empty" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value!.isEmpty ? "Email cannot be empty" : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                validator: (value) =>
                    value!.isEmpty ? "Phone cannot be empty" : null,
              ),
              TextFormField(
                controller: _nbHoursController,
                decoration: const InputDecoration(labelText: "Number of Hours"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Hours cannot be empty" : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password (Optional)"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              const Text("Subjects"),
              ...subjects.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> subject = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: subject['name'],
                        decoration: const InputDecoration(labelText: "Subject Name"),
                        onChanged: (value) {
                          setState(() {
                            subjects[index]['name'] = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeSubject(index),
                    ),
                  ],
                );
              }),
              ElevatedButton(
                onPressed: _addSubject,
                child: const Text("Add Subject"),
              ),
              const SizedBox(height: 20),
              const Text("Activities"),
              ...activities.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> activity = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: activity['name'],
                        decoration: const InputDecoration(labelText: "Activity Name"),
                        onChanged: (value) {
                          setState(() {
                            activities[index]['name'] = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeActivity(index),
                    ),
                  ],
                );
              }),
              ElevatedButton(
                onPressed: _addActivity,
                child: const Text("Add Activity"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.appBarColor),
                ),
                onPressed: _editTeacher,
                child: const Text("Update Teacher"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
