import 'package:flutter/material.dart';
import 'package:smarn/models/change_request_status.dart';
import 'package:smarn/models/change_request.dart';
import 'package:smarn/services/change_request_service.dart';

class RequestForm extends StatelessWidget {
  RequestForm({super.key});

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _newTimeSlotController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _availableRooms = ['RM001']; // Example room list
  String? _selectedRoom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Changes"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color(0xFF2C2C2C),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Describe your complaint or request changes below:",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Reason field
                    TextFormField(
                      controller: _reasonController,
                      decoration: InputDecoration(
                        hintText: 'Enter reason for the request',
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Reason is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Description field
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter your description here',
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // New Room dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedRoom,
                      items: _availableRooms
                          .map((room) => DropdownMenuItem(
                                value: room,
                                child: Text(room, style: const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                      dropdownColor: Colors.grey[800],
                      decoration: InputDecoration(
                        hintText: 'Select new room',
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        _selectedRoom = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a new room';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // New Time Slot field
                    TextFormField(
                      controller: _newTimeSlotController,
                      decoration: InputDecoration(
                        hintText: 'Enter new time slot',
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'New time slot is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final confirmed = await _showConfirmationDialog(context);
                          if (confirmed) {
                            await _submitRequest(context);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show confirmation dialog before submission
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Submission"),
            content: const Text("Are you sure you want to submit this request?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Submit"),
              ),
            ],
          ),
        ) ??
        false;
  }

  // Submit the request
  Future<void> _submitRequest(BuildContext context) async {
    final changeRequest = ChangeRequest(
      reason: _reasonController.text.trim(),
      content: _descriptionController.text.trim(),
      newRoom: _selectedRoom,
      newTimeSlot: _newTimeSlotController.text.trim(),
      teacher: "TeacherID123", // Replace with actual teacher identifier
      submissionDate: DateTime.now().toIso8601String(),
      status: ChangeRequestStatus.pending,
    );

    final response = await ChangeRequestService().addChangeRequest(changeRequest);

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request submitted successfully!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response['message']}")),
      );
    }
  }
}
