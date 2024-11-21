import 'package:flutter/material.dart';
import 'package:smarn/models/activity.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/services/class_service.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/services/subject_service.dart';
import 'package:smarn/services/activity_service.dart';
import 'package:smarn/services/room_service.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({Key? key}) : super(key: key);

  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  String? _selectedClass;
  String? _selectedTag;
  String? _selectedTeacher;
  String? _selectedSubject;
  String? _selectedRoom;

  List<String> _classes = [];
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
  }

  Future<void> _fetchData() async {
    await Future.wait([
      _fetchTeachers(),
      _fetchSubjects(),
      _fetchRooms(),
      _fetchClasses(), // Add dynamic class fetching if applicable
    ]);
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
  //methode to get all classes
Future<void> _fetchClasses() async {
  try {
    final List<Class> fetchedClasses = await ClassService().getAllclasses();

    setState(() {
      _classes = fetchedClasses.map((c) => c.name).toList(); // Extract the name property
    });
  } catch (e) {
    print('Error fetching classes: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to fetch classes')),
    );
  }
}

  void _saveActivity() {
    if (_formIsValid()) {
      final activity = Activity(
        subject: _selectedSubject!,
        teacher: _selectedTeacher!,
        studentsClass: _selectedClass!,
        duration: int.parse(_durationController.text),
        tag: ActivityTag.values.firstWhere((e) => e.name == _selectedTag),
        room: _selectedRoom!,
      );
      ActivityService().addActivity(activity);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields and ensure the duration is at least 60 minutes.')),
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
        title: const Text('Add New Activity'),
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
                decoration: InputDecoration(
                  labelText: 'Activity Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Subject Dropdown
              DropdownButton<String>(
                hint: const Text("Select Subject", style: TextStyle(color: Colors.white)),
                value: _selectedSubject,
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
                hint: const Text("Select Teacher", style: TextStyle(color: Colors.white)),
                value: _selectedTeacher,
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
                hint: const Text("Select Class", style: TextStyle(color: Colors.white)),
                value: _selectedClass,
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

              // Duration (in minutes)
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
                hint: const Text("Select Tag", style: TextStyle(color: Colors.white)),
                value: _selectedTag,
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
                hint: const Text("Select Room", style: TextStyle(color: Colors.white)),
                value: _selectedRoom,
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
                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 129, 77, 139)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
