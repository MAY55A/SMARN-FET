import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  late TextEditingController _passwordController;  // New controller for password
  bool _obscureText = true;  // Toggle for password visibility

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.teacher.name);
    _nbHoursController =
        TextEditingController(text: widget.teacher.nbHours.toString());
    _emailController = TextEditingController(text: widget.teacher.email);
    _phoneController = TextEditingController(text: widget.teacher.phone);
    _passwordController = TextEditingController();  // Initialize password controller
  }

  // Function to show the confirmation dialog
  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800], // Gray background for the dialog
          title: const Text(
            "Confirm Changes",
            style: TextStyle(color: Colors.white), // White title text
          ),
          content: const Text(
            "Are you sure you want to save changes?",
            style: TextStyle(color: Colors.white), // White content text
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // No button
              },
              child: const Text(
                "No",
                style: TextStyle(color: Colors.white), // White text for buttons
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Yes button
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.white), // White text for buttons
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateTeacher() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get the currently authenticated user
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          // User is not authenticated or not authorized to update
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'You don\'t have permission to edit this information.')));
          return;
          
        }

        Teacher updatedTeacher = Teacher(
          id: widget.teacher.id,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          nbHours: int.parse(_nbHoursController.text.trim()),
          picture: widget.teacher.picture,
          subjects: widget.teacher.subjects,
        );

        // Only update password if it's not empty
        String? newPassword = _passwordController.text.trim();
        if (newPassword.isNotEmpty) {
          // Assuming we also update the password
          user.updatePassword(newPassword).then((_) {
            print("Password updated successfully.");
          }).catchError((error) {
            print("Error updating password: $error");
          });
        }

        if (!updatedTeacher.equals(widget.teacher)) {
          if (await _showConfirmationDialog() == true) {
            final response = await TeacherService().updateTeacher(
              user.uid, 
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
    // Check screen size for web version (adjust card size)
    double cardWidth = MediaQuery.of(context).size.width > 600 ? 500 : 350;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Personnel Information"),
        backgroundColor: Colors.blue, // Blue AppBar
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
              width: cardWidth, // Dynamic card width based on screen size
              decoration: BoxDecoration(
                color: Colors.grey[850], // Gray background color for card
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
                      style: const TextStyle(
                          color: Colors.white), // White text for input
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.blue),
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
                      style: const TextStyle(
                          color: Colors.white), // White text for input
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.blue),
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
                      style: const TextStyle(
                          color: Colors.white), // White text for input
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.blue),
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
                      style: const TextStyle(
                          color: Colors.white), // White text for input
                      decoration: const InputDecoration(
                        labelText: "Target Hours",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.blue),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Number of target hours is required.";
                        }
                        if (int.tryParse(value)! <= 0 &&
                            int.tryParse(value)! > 40) {
                          return "Number of target hours should be between 1 and 40.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password field with eye icon
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "New Password",
                        border: const OutlineInputBorder(),
                        labelStyle: const TextStyle(color: Colors.blue),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateTeacher,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF023E8A),
                        foregroundColor: const Color.fromARGB(
                            255, 255, 255, 255), // Blue button color
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                      ),
                      child: const Text("Save Changes"),
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
