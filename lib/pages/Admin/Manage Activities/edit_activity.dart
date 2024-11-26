import 'package:flutter/material.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class EditActivity extends StatefulWidget {
  final Map<String, dynamic> activity;

  const EditActivity({super.key, required this.activity});

  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  String? _selectedClass;
  String? _selectedTag;

  final List<String> _classes = ['Class A', 'Class B', 'Class C'];
  final List<String> _tags = ['Lecture', 'Practical', 'Workshop'];

  @override
  void initState() {
    super.initState();
    // Pre-fill form fields with the existing activity data
    _nameController.text = widget.activity['name'];
    _subjectController.text = widget.activity['subject'];
    _teacherController.text = widget.activity['teacher'];
    _roomController.text = widget.activity['room'];
    _durationController.text = widget.activity['duration'].toString();
    _selectedClass = widget.activity['className'];
    _selectedTag = widget.activity['tag'];
  }

  void _saveActivity() {
    if (_nameController.text.isNotEmpty &&
        _subjectController.text.isNotEmpty &&
        _teacherController.text.isNotEmpty &&
        _selectedClass != null &&
        _selectedTag != null &&
        _roomController.text.isNotEmpty &&
        _durationController.text.isNotEmpty) {
      // Simulate saving activity logic
      print('Updated Activity: ${_nameController.text}');
      Navigator.pop(context, {
        'id': widget.activity['id'],
        'name': _nameController.text,
        'subject': _subjectController.text,
        'teacher': _teacherController.text,
        'className': _selectedClass,
        'tag': _selectedTag,
        'room': _roomController.text,
        'duration': int.parse(_durationController.text),
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Activity'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Activity Name',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _subjectController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _teacherController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Teacher',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: _selectedClass,
                hint: const Text("Select Class",
                    style: TextStyle(color: Colors.white)),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedClass = newValue;
                  });
                },
                items: _classes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                dropdownColor: Colors.black,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _durationController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duration (Minutes)',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: _selectedTag,
                hint: const Text("Select Tag",
                    style: TextStyle(color: Colors.white)),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTag = newValue;
                  });
                },
                items: _tags.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                dropdownColor: Colors.black,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _roomController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Room Number',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveActivity,
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(Colors.black),
                  backgroundColor:
                      WidgetStateProperty.all(AppColors.appBarColor),
                ),
                child: const Text('Save Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
