import 'package:flutter/material.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({super.key});

  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  // Controllers for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  // Selected values for dropdowns
  String? _selectedClass;
  String? _selectedTag;

  // List of available classes and tags for dropdowns
  final List<String> _classes = ['Class A', 'Class B', 'Class C'];
  final List<String> _tags = [
    'lecture',
    'lab',
    'seminar',
    'workshop',
    'exam',
    'other'
  ];

  // Function to handle the save button press
  void _saveActivity() {
    if (_nameController.text.isNotEmpty &&
        _subjectController.text.isNotEmpty &&
        _teacherController.text.isNotEmpty &&
        _selectedClass != null &&
        _selectedTag != null &&
        _roomController.text.isNotEmpty &&
        _durationController.text.isNotEmpty) {
      // Here, you would add the new activity to your list
      // For example:
      print('New Activity Added: ${_nameController.text}');

      // Go back to the previous screen (ManageActivitiesForm)
      Navigator.pop(context);
    } else {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color
      appBar: AppBar(
        title: const Text('Add New Activity'),
        backgroundColor:
            const Color.fromARGB(255, 129, 77, 139), // Purple background
        foregroundColor: Colors.white, // White text
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Activity Name
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

              // Subject
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

              // Teacher
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

              // Class Dropdown
              DropdownButton<String>(
                hint: const Text("Select Class",
                    style: TextStyle(color: Colors.white)),
                value: _selectedClass,
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
                dropdownColor: Colors.black, // Set dropdown background to black
              ),
              const SizedBox(height: 16),

              // Duration (in minutes)
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

              // Tag Dropdown
              DropdownButton<String>(
                hint: const Text("Select Tag",
                    style: TextStyle(color: Colors.white)),
                value: _selectedTag,
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
                dropdownColor: Colors.black, // Set dropdown background to black
              ),
              const SizedBox(height: 16),

              // Room Number
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

              // Save Button
              ElevatedButton(
                  onPressed: _saveActivity,
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.black),
                    backgroundColor:
                        WidgetStateProperty.all(AppColors.appBarColor),
                  ),
                  child: const Text('Save Activity') // Purple color

                  ),
            ],
          ),
        ),
      ),
    );
  }
}
