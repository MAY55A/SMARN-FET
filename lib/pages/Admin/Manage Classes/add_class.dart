

import 'package:flutter/material.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/class_service.dart';
import 'dart:math'; // Import the math library for random number generation

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

  bool _isLoading = false;

  String _generateAccessKey() {
    const length = 6;
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();

    String key = List.generate(length, (index) {
      return characters[random.nextInt(characters.length)];
    }).join();

    return key;
  }

  void _addClass() async {
    if (_nameController.text.isNotEmpty &&
        _longNameController.text.isNotEmpty &&
        _nbStudentsController.text.isNotEmpty) {
      setState(() => _isLoading = true);

      final newClass = Class(
        name: _nameController.text,
        longName: _longNameController.text,
        nbStudents: int.parse(_nbStudentsController.text),
        accessKey: _accessKeyController.text.isEmpty
            ? _generateAccessKey()
            : _accessKeyController.text,
      );

      final response = await ClassService().createClass(newClass);

      setState(() => _isLoading = false);

      if (response['success']) {
        Navigator.pop(context, newClass);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
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
        backgroundColor: AppColors.appBarColor,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 600), // Limiter la largeur de la carte
                  child: Card(
                    color: Colors.grey[850],
                    elevation: 8,
                    child: Padding(
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
                            buildTextField('Access Key', _accessKeyController),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _accessKeyController.text = _generateAccessKey();
                                });
                              },
                              icon: const Icon(Icons.refresh, color: Colors.white),
                              label: const Text('Generate Key', style: TextStyle(color: Colors.white)),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.purple),
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: _addClass,
                              child: const Text('Add Class'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(AppColors.appBarColor),
                                foregroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
}
