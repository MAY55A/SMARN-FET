import 'package:flutter/material.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/pages/widgets/canstants.dart';
// Import the Class model

class EditClass extends StatefulWidget {
  final Class classItem;
  const EditClass({super.key, required this.classItem});

  @override
  State<EditClass> createState() => _EditClassState();
}

class _EditClassState extends State<EditClass> {
  late TextEditingController _nameController;
  late TextEditingController _longNameController;
  late TextEditingController _nbStudentsController;
  late TextEditingController _accessKeyController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.classItem.name);
    _longNameController = TextEditingController(text: widget.classItem.longName);
    _nbStudentsController = TextEditingController(text: widget.classItem.nbStudents.toString());
    _accessKeyController = TextEditingController(text: widget.classItem.accessKey);
  }

  void _saveChanges() {
    if (_nameController.text.isNotEmpty &&
        _longNameController.text.isNotEmpty &&
        _nbStudentsController.text.isNotEmpty &&
        _accessKeyController.text.isNotEmpty) {
      // Save changes
      final updatedClass = Class(
        id: widget.classItem.id,
        name: _nameController.text,
        longName: _longNameController.text,
        nbStudents: int.parse(_nbStudentsController.text),
        accessKey: _accessKeyController.text,
      );

      Navigator.pop(context, updatedClass); // Return the updated class
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
        title: const Text('Edit Class'),
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
                decoration: InputDecoration(
                  labelText: 'Class Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _longNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Long Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nbStudentsController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of Students',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _accessKeyController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Access Key',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
                 style: ButtonStyle(
     foregroundColor: MaterialStateProperty.all(Colors.black),
     backgroundColor: MaterialStateProperty.all(AppColors.appBarColor),
                 )     
              ),
            ],
          ),
        ),
      ),
    );
  }
}
