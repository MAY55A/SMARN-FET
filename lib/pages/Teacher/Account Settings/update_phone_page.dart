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
      appBar: AppBar(
        title: const Text('Update Phone Number'),
        backgroundColor: Colors.blue, // Blue AppBar
      ),
      body: Container(
        color: Colors.black, // Black background for the page
        child: Center(
          child: Card(
            color: Colors.grey[800], // Gray background for the card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Rounded corners
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'New Phone Number',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updatePhoneNumber,
                    child: const Text('Update Phone Number'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Blue button background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
