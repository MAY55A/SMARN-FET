import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/teacher_service.dart';

class EditPersonnelInformationForm extends StatefulWidget {
  final Teacher teacher;
  final String teacherId;

  const EditPersonnelInformationForm(
      {super.key, required this.teacher, required this.teacherId});

  @override
  _EditPersonnelInformationFormState createState() =>
      _EditPersonnelInformationFormState();
}

class _EditPersonnelInformationFormState
    extends State<EditPersonnelInformationForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nbHoursController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.teacher.name);
    _nbHoursController =
        TextEditingController(text: widget.teacher.nbHours.toString());
    _emailController = TextEditingController(text: widget.teacher.email);
    _phoneController = TextEditingController(text: widget.teacher.phone);
  }

  // Function to show the confirmation dialog
  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Changes"),
          content: const Text("Are you sure you want to save changes?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // No button
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Yes button
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _updateTeacher() async {
    if (_formKey.currentState!.validate()) {
      try {
        Teacher updatedTeacher = Teacher(
          id: widget.teacher.id,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          nbHours: int.parse(_nbHoursController.text.trim()),
          picture: widget.teacher.picture,
          subjects: widget.teacher.subjects,
        );

        if (!updatedTeacher.equals(widget.teacher)) {
          if (await _showConfirmationDialog() == true) {
            final response = await TeacherService().updateTeacher(
              widget.teacherId,
              updatedTeacher,
            );

            if (response['success']) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Your personal info was updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      response['message'] ?? 'Failed to update personal info.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No changes were made.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating teacher: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Personnel Information"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.black87, // Dark background color
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(
                    0xFFE0F7FA), // Light blue background for the form
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Form fields to edit personnel info
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Color(0xFF023E8A)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Color(0xFF023E8A)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required.";
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return "Enter a valid email address.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Color(0xFF023E8A)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone is required.";
                        }
                        if (value.length != 8 ||
                            !RegExp(r'^\d+$').hasMatch(value)) {
                          return "Phone number must be 8 digits.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nbHoursController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: const InputDecoration(
                        labelText: "Target Hours",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Color(0xFF023E8A)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Number of target hours is required.";
                        }
                        if (int.tryParse(value)! <= 0 &&
                            int.tryParse(value)! > 40) {
                          return "Number of target hours must be between 0 and 40.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Save button
                    ElevatedButton(
                      onPressed: _updateTeacher,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

