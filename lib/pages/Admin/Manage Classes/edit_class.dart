import 'package:flutter/material.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/class_service.dart'; // Import the class service
import 'dart:math'; // Import the math library for random number generation

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

  final ClassService _classService = ClassService();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.classItem.name);
    _longNameController =
        TextEditingController(text: widget.classItem.longName);
    _nbStudentsController =
        TextEditingController(text: widget.classItem.nbStudents.toString());
    _accessKeyController =
        TextEditingController(text: widget.classItem.accessKey ?? '');
  }

  void _saveChanges() async {
    if (_nameController.text.isNotEmpty &&
        _longNameController.text.isNotEmpty &&
        _nbStudentsController.text.isNotEmpty) {
      setState(() => _isLoading = true);

      final updatedClass = Class(
        id: widget.classItem.id,
        name: _nameController.text,
        longName: _longNameController.text,
        nbStudents: int.parse(_nbStudentsController.text),
        accessKey: _accessKeyController.text,
      );

      final response = await _classService.updateClass(
          widget.classItem.id!, updatedClass);

      setState(() => _isLoading = false);

      if (response['success']) {
        Navigator.pop(context, updatedClass);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
    }
  }

  // Reset the access key locally
  Future<void> _resetKey() async {
    if (widget.classItem.id == null) return;

    setState(() => _isLoading = true);
    final newKey = _generateAccessKey(); // Generate new key locally

    setState(() {
      _accessKeyController.text = newKey; // Update the controller with the new key
    });

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Access key reset successfully!')),
    );
  }

  // Key generation method that includes letters and digits
  String _generateAccessKey() {
    const length = 6; // Length of the generated key
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'; // Alphanumeric characters
    Random random = Random();

    // Generate a random key of the specified length
    String key = List.generate(length, (index) {
      return characters[random.nextInt(characters.length)];
    }).join();

    return key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Class'),
        backgroundColor: AppColors.appBarColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildTextField('Class Name', _nameController),
                    const SizedBox(height: 16),
                    buildTextField('Long Name', _longNameController),
                    const SizedBox(height: 16),
                    buildTextField(
                      'Number of Students',
                      _nbStudentsController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    buildTextFieldWithButton(
                      'Access Key',
                      _accessKeyController,
                      'Reset Key',
                      _resetKey,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text('Save Changes'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            AppColors.appBarColor),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple),
        ),
      ),
    );
  }

  Widget buildTextFieldWithButton(
    String label,
    TextEditingController controller,
    String buttonLabel,
    VoidCallback onButtonPressed, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.white),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onButtonPressed,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(AppColors.appBarColor),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: Text(buttonLabel),
        ),
      ],
    );
  }
}
