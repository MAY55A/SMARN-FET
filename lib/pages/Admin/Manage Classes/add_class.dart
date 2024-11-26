import 'package:flutter/material.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/class_service.dart';

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

  final ClassService _classService = ClassService();

  bool _isLoading = false;

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
            ? null
            : _accessKeyController.text,
      );

      final response = await _classService.createClass(newClass);

      setState(() => _isLoading = false);

      if (response['success']) {
        Navigator.pop(context, newClass);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Add Class'),
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
                    buildTextField(
                        'Access Key (Optional)', _accessKeyController),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _addClass,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppColors.appBarColor),
                      ),
                      child: const Text('Add Class'),
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
}
