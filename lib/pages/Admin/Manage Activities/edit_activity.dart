import 'package:flutter/material.dart';
import 'package:smarn/models/activity.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/services/activity_service.dart';
import 'package:smarn/services/subject_service.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/services/room_service.dart';
import 'package:smarn/models/room.dart';

class EditActivity extends StatefulWidget {
  final Map<String, dynamic> activity;

  const EditActivity({Key? key, required this.activity}) : super(key: key);

  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  String? _selectedClass;
  String? _selectedTag;
  String? _selectedTeacher;
  String? _selectedSubject;
  String? _selectedRoom;

  List<String> _classes = [];
  //List of the tags
  List<String> _tags = ['lecture', 'lab', 'seminar', 'workshop', 'exam', 'other'];
  List<dynamic> _teachers = [];
  List<String> _subjects = [];
  List<Room> _rooms = [];

  final TeacherService _teacherService = TeacherService();
  final SubjectService _subjectService = SubjectService();
  final RoomService _roomService = RoomService();

  @override
  void initState() {
    super.initState();
    _fetchData();

    // Pre-fill fields with existing data
    _nameController.text = widget.activity['name'] ?? '';
    _durationController.text = widget.activity['duration']?.toString() ?? '';
    _selectedClass = widget.activity['studentsClass'];
    _selectedTag = widget.activity['tag'];
    _selectedTeacher = widget.activity['teacher'];
    _selectedSubject = widget.activity['subject'];
    _selectedRoom = widget.activity['room'];
  }

  Future<void> _fetchData() async {
    await Future.wait([
      _fetchTeachers(),
      _fetchSubjects(),
      _fetchRooms(),
      _fetchClasses(), // Replace with dynamic class fetching logic if needed
    ]);

    // Validate the selected values after fetching data
    setState(() {
      if (_selectedClass != null && !_classes.contains(_selectedClass)) {
        _selectedClass = _classes.isNotEmpty ? _classes[0] : null;
      }
      if (_selectedTag != null && !_tags.contains(_selectedTag)) {
        _selectedTag = _tags.isNotEmpty ? _tags[0] : null;
      }
      if (_selectedTeacher != null && !_teachers.contains(_selectedTeacher)) {
        _selectedTeacher = _teachers.isNotEmpty ? _teachers[0] : null;
      }
      if (_selectedSubject != null && !_subjects.contains(_selectedSubject)) {
        _selectedSubject = _subjects.isNotEmpty ? _subjects[0] : null;
      }
      if (_selectedRoom != null && !_rooms.map((e) => e.name).contains(_selectedRoom)) {
        _selectedRoom = _rooms.isNotEmpty ? _rooms[0].name : null;
      }
    });
  }

  Future<void> _fetchTeachers() async {
    final teachersList = await _teacherService.getAllTeachers();
    setState(() {
      _teachers = teachersList.map((teacher) => teacher['teacher'].name).toList();
    });
  }

  Future<void> _fetchSubjects() async {
    final subjectsList = await _subjectService.getAllSubjects();
    setState(() {
      _subjects = subjectsList.map((subject) => subject.name).toList();
    });
  }

  Future<void> _fetchRooms() async {
    final roomsList = await _roomService.getAllRooms();
    setState(() {
      _rooms = roomsList;
    });
  }

  Future<void> _fetchClasses() async {
    // Replace with API call for dynamic class fetching
    setState(() {
      _classes = ['Class A', 'Class B', 'Class C']; // Example data
    });
  }

  void _saveActivity() async {
    if (_formIsValid()) {
      final updatedActivity = Activity(
        id: widget.activity['id'],
        subject: _selectedSubject!,
        teacher: _selectedTeacher!,
        studentsClass: _selectedClass!,
        duration: int.parse(_durationController.text),
        tag: ActivityTag.values.firstWhere((e) => e.name == _selectedTag),
        room: _selectedRoom!,
      );

      final result = await ActivityService().updateActivity(widget.activity['id'], updatedActivity);

      if (result['success'] == true) {
        Navigator.pop(context, updatedActivity);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating activity: ${result['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
    }
  }

  bool _formIsValid() {
    return _nameController.text.isNotEmpty &&
        _selectedSubject != null &&
        _selectedTeacher != null &&
        _selectedClass != null &&
        _selectedTag != null &&
        _selectedRoom != null &&
        _durationController.text.isNotEmpty &&
        int.tryParse(_durationController.text) != null &&
        int.parse(_durationController.text) >= 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Activity'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Activity Name
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Activity Name',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Subject Dropdown
              DropdownButton<String>(
                value: _selectedSubject,
                hint: const Text("Select Subject", style: TextStyle(color: Colors.white)),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSubject = newValue;
                  });
                },
                items: _subjects.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                dropdownColor: Colors.black,
              ),
              const SizedBox(height: 16),

              // Teacher Dropdown
              DropdownButton<String>(
                value: _selectedTeacher,
                hint: const Text("Select Teacher", style: TextStyle(color: Colors.white)),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTeacher = newValue;
                  });
                },
                items: _teachers.map<DropdownMenuItem<String>>((dynamic value) {
                  return DropdownMenuItem<String>(
                    value: value as String,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                dropdownColor: Colors.black,
              ),
              const SizedBox(height: 16),

              // Class Dropdown
              DropdownButton<String>(
                value: _selectedClass,
                hint: const Text("Select Class", style: TextStyle(color: Colors.white)),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedClass = newValue;
                  });
                },
                items: _classes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                dropdownColor: Colors.black,
              ),
              const SizedBox(height: 16),

              // Duration TextField
              TextField(
                controller: _durationController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duration (Minutes)',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Tag Dropdown
              DropdownButton<String>(
                value: _selectedTag,
                hint: const Text("Select Tag", style: TextStyle(color: Colors.white)),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTag = newValue;
                  });
                },
                items: _tags.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                dropdownColor: Colors.black,
              ),
              const SizedBox(height: 16),

              // Room Dropdown
              DropdownButton<String>(
                value: _selectedRoom,
                hint: const Text("Select Room", style: TextStyle(color: Colors.white)),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRoom = newValue;
                  });
                },
                items: _rooms.map<DropdownMenuItem<String>>((Room room) {
                  return DropdownMenuItem<String>(
                    value: room.name,
                    child: Text(room.name, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                dropdownColor: Colors.black,
              ),
              const SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: _saveActivity,
                child: const Text('Save Activity'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
