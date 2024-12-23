import 'package:flutter/material.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/models/teacher.dart';

class UpdatePhoneNumberPage extends StatefulWidget {
  const UpdatePhoneNumberPage({super.key});

  @override
  _UpdatePhoneNumberPageState createState() => _UpdatePhoneNumberPageState();
}

class _UpdatePhoneNumberPageState extends State<UpdatePhoneNumberPage> {
  final TeacherService _teacherService = TeacherService();
  final _phoneNumberController = TextEditingController();
  Teacher? currentTeacher;

  @override
  void initState() {
    super.initState();
    _loadCurrentPhoneNumber();
  }

  void _loadCurrentPhoneNumber() async {
    final teacher = await _teacherService.fetchTeacherData();
    if (teacher != null) {
      setState(() {
        _phoneNumberController.text = teacher.phone ?? '';
        currentTeacher = teacher;
      });
    }
  }

  Future<void> _updatePhoneNumber() async {
    final phoneNumber = _phoneNumberController.text.trim();
    if (phoneNumber.isEmpty || phoneNumber.length < 8) {
      _showError('Please enter a valid phone number.');
      return;
    }

    try {
      if (currentTeacher != null) {
        currentTeacher!.phone = phoneNumber; // Update the phone number
        await _teacherService.updateTeacher(currentTeacher!.id!, currentTeacher!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone number updated successfully!')),
        );
        Navigator.pop(context); // Go back to the previous screen
      }
    } catch (e) {
      _showError('Error updating phone number: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Phone Number')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'New Phone Number'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updatePhoneNumber,
              child: const Text('Update Phone Number'),
            ),
          ],
        ),
      ),
    );
  }
}
