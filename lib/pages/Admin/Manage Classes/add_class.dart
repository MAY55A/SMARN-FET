import 'package:flutter/material.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/pages/widgets/canstants.dart';
 // Import the Class model

class AddClass extends StatefulWidget {
  const AddClass({super.key});

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _longNameController = TextEditingController();
  final TextEditingController _nbStudentsController = TextEditingController();
  final TextEditingController _accessKeyController = TextEditingController();

  void _addClass() {
    if (_nameController.text.isNotEmpty &&
        _longNameController.text.isNotEmpty &&
        _nbStudentsController.text.isNotEmpty &&
        _accessKeyController.text.isNotEmpty) {
      // Simulate adding class logic
      final newClass = Class(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        longName: _longNameController.text,
        nbStudents: int.parse(_nbStudentsController.text),
        accessKey: _accessKeyController.text,
      );

      Navigator.pop(context, newClass); // Return the new class to the ManageClasses screen
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
        title: const Text('Add Class'),
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
                onPressed: _addClass,
                child: const Text('Add Class'),
                 style: ButtonStyle(
                 foregroundColor: MaterialStateProperty.all(Colors.black),
                 backgroundColor: MaterialStateProperty.all(AppColors.appBarColor),
                ),
          
                ),
            ],
          ),
        ),
      ),
    );
  }
}
