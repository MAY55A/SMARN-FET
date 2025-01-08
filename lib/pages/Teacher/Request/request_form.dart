import 'package:flutter/material.dart';
import 'package:smarn/models/change_request.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/services/activity_service.dart';
import 'package:smarn/services/auth_service.dart';
import 'package:smarn/services/change_request_service.dart';
import 'package:smarn/services/room_service.dart';
import 'package:smarn/services/teacher_service.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({Key? key}) : super(key: key);

  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _newTimeSlotController = TextEditingController();

  List<Room> _availableRooms = [];
  List<Map<String, dynamic>> _availableActivities = [];
  Room? _selectedRoom;
  Map<String, dynamic>? _selectedActivity;

  @override
  void initState() {
    super.initState();
    _fetchActivities();
    _fetchRooms();
  }

  Future<void> _fetchActivities() async {
    final activitiesList = await ActivityService()
        .getActivitiesByTeacher(AuthService().getCurrentUser()!.uid);
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
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor:const Color(0xFF2C2C2C),
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
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFF2C2C2C),
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              width: isWeb ? 600 : double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildDescriptionField(),
                    const SizedBox(height: 20),
                    _buildReasonField(),
                    const SizedBox(height: 20),
                    _buildActivityDropdown(),
                    const SizedBox(height: 20),
                    _buildRoomDropdown(),
                    const SizedBox(height: 20),
                    _buildTimeSlotField(),
                    const SizedBox(height: 20),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      "Describe your complaint or request changes below:",
      style: TextStyle(fontSize: 18, color: Colors.blue),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 5,
      decoration: _inputDecoration("Enter description for the changes"),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Description is required';
        }
        return null;
      },
    );
  }

  Widget _buildReasonField() {
    return TextFormField(
      controller: _reasonController,
      decoration: _inputDecoration("Enter reason for the request"),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Reason is required';
        }
        return null;
      },
    );
  }

  Widget _buildActivityDropdown() {
    return DropdownButtonFormField<Map<String, dynamic>>(
      value: _selectedActivity,
      items: [null, ..._availableActivities]
          .map(
            (activity) => DropdownMenuItem(
              value: activity,
              child: Text(
                activity == null
                    ? "Select concerned activity"
                    : "${activity['subject']['longName']} - ${activity['studentsClass']['name']} - ${activity['day'] ?? "unknown day"}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
          .toList(),
      dropdownColor: Colors.grey[800],
      decoration: _inputDecoration("Select concerned activity (optional)"),
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          _selectedActivity = value;
        });
      },
    );
  }

  Widget _buildRoomDropdown() {
    return DropdownButtonFormField<Room>(
      value: _selectedRoom,
      items: [null, ..._availableRooms]
          .map(
            (room) => DropdownMenuItem(
              value: room,
              child: Text(
                room == null ? "Select new room" : room.name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
          .toList(),
      dropdownColor: Colors.grey[800],
      decoration: _inputDecoration("Select new room (optional)"),
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          _selectedRoom = value;
        });
      },
    );
  }

  Widget _buildTimeSlotField() {
    return TextFormField(
      controller: _newTimeSlotController,
      decoration: _inputDecoration("Enter new time slot (optional)"),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Submit',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Submission"),
            content:
                const Text("Are you sure you want to submit this request?"),
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

  Future<void> _submitRequest(BuildContext context) async {
    final teacher = await TeacherService().fetchTeacherData();
    final teacherId = teacher!.id!;
    final changeRequest = ChangeRequest(
      reason: _reasonController.text.trim(),
      content: _descriptionController.text.trim(),
      newRoom: _selectedRoom?.id,
      activity: _selectedActivity?['id'],
      newTimeSlot: _newTimeSlotController.text.trim(),
      teacher: teacherId,
    );

    final response =
        await ChangeRequestService().addChangeRequest(changeRequest);

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

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
