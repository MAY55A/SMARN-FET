import 'package:flutter/material.dart';
import 'package:smarn/models/change_request.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/services/activity_service.dart';
import 'package:smarn/services/auth_service.dart';
import 'package:smarn/services/change_request_service.dart';
import 'package:smarn/services/room_service.dart';

class EditRequestForm extends StatefulWidget {
  final ChangeRequest request;

  const EditRequestForm({Key? key, required this.request}) : super(key: key);

  @override
  _EditRequestFormState createState() => _EditRequestFormState();
}

class _EditRequestFormState extends State<EditRequestForm> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _newTimeSlotController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Room> _availableRooms = [];
  List<Map<String, dynamic>> _availableActivities = [];

  Room? _selectedRoom;
  Map<String, dynamic>? _selectedActivity;
  bool _isLoading = false;

  Future<void> _fetchActivities() async {
    final activitiesList = (await ActivityService()
        .getActivitiesByTeacher(AuthService().getCurrentUser()!.uid));
    setState(() {
      _availableActivities = activitiesList;
    });
  }

  Future<void> _fetchRooms() async {
    final roomsList = await RoomService().getAllRooms();
    setState(() {
      _availableRooms = roomsList;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchActivities();
    _fetchRooms();
    _descriptionController.text = widget.request.content;
    _reasonController.text = widget.request.reason;
    _newTimeSlotController.text = widget.request.newTimeSlot ?? '';
    _selectedRoom = widget.request.newRoom != null
        ? _availableRooms.firstWhere(
            (room) => room.id == widget.request.newRoom)
        : null;
    _selectedActivity = widget.request.activity != null
        ? _availableActivities.firstWhere(
            (activity) => activity['id'] == widget.request.activity)
        : null;
  }

  Future<void> _updateRequest() async {
    setState(() {
      _isLoading = true;
    });

    final updatedRequest = ChangeRequest(
      id: widget.request.id,
      reason: _reasonController.text.trim(),
      content: _descriptionController.text.trim(),
      newRoom: _selectedRoom?.id,
      activity: _selectedActivity?['id'],
      newTimeSlot: _newTimeSlotController.text.trim(),
      teacher: widget.request.teacher,
    );

    final response = await ChangeRequestService().updateChangeRequest(
      widget.request.id!,
      updatedRequest,
    );

    if (response['success']) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update request: ${response['message']}')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Request"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600), // Set max width for web
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter your description for the changes you wish to be made',
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
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: _selectedActivity,
                      items: [null, ..._availableActivities]
                          .map((activity) => DropdownMenuItem(
                                value: activity,
                                child: Text(
                                  activity == null
                                      ? "Select concerned activity"
                                      : "${activity['subject']['longName']} - ${activity["studentsClass"]["name"]} - ${activity["day"] ?? "unknown day"}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      dropdownColor: Colors.grey[800],
                      decoration: InputDecoration(
                        hintText: 'Select concerned activity (optional)',
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
                        _selectedActivity = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<Room>(
                      value: _selectedRoom,
                      items: [null, ..._availableRooms]
                          .map((room) => DropdownMenuItem(
                                value: room,
                                child: Text(
                                  room == null ? "Select new room" : room.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      dropdownColor: Colors.grey[800],
                      decoration: InputDecoration(
                        hintText: 'Select new room (optional)',
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
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _newTimeSlotController,
                      decoration: InputDecoration(
                        hintText: 'Enter new time slot (optional)',
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _updateRequest();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Update Request',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF2C2C2C),
    );
  }
}
