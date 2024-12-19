import 'package:flutter/material.dart';
import 'package:smarn/models/activity.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/models/room.dart'; 
import 'package:smarn/pages/widgets/dropDownMenu.dart';
import 'package:smarn/services/class_service.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/services/subject_service.dart';
import 'package:smarn/services/activity_service.dart';
import 'package:smarn/services/room_service.dart';

class EditActivity extends StatefulWidget {
  final Map<String, dynamic> activity;

  const EditActivity({Key? key, required this.activity}) : super(key: key);

  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  final List<String> _tags = ActivityTag.values.map((a) => a.name).toList();

  Class? _selectedClass;
  String? _selectedTag;
  Teacher? _selectedTeacher;
  Subject? _selectedSubject;
  Room? _selectedRoom;
  String? _selectedDay; // Changed to string

  List<Class> _classes = [];
  List<Teacher> _allTeachers = [];
  List<Subject> _allSubjects = [];
  List<Teacher> _teachers = [];
  List<Subject> _subjects = [];
  List<Room> _rooms = [];
  List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']; // List of working days

  final TeacherService _teacherService = TeacherService();
  final SubjectService _subjectService = SubjectService();
  final ClassService _classService = ClassService();
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
      _fetchClasses(),
    ]);

    // Pre-fill fields with existing data
    setState(() {
      _durationController.text = widget.activity['duration']?.toString() ?? '';
      _startTimeController.text = widget.activity['startTime'] ?? '';
      _endTimeController.text = widget.activity['endTime'] ?? '';
      _selectedClass = _classes.firstWhere((c) => c.id == widget.activity['studentsClass']['id']);
      _selectedTag = widget.activity['tag'];
      _selectedTeacher = _allTeachers.firstWhere((t) => t.id == widget.activity['teacher']['id']);
      _selectedSubject = _allSubjects.firstWhere((s) => s.id == widget.activity['subject']['id']);
      _selectedRoom = widget.activity['room'] != null
          ? _rooms.firstWhere((r) => r.id == widget.activity['room']['id'])
          : null;
      _selectedDay = widget.activity['day']; // Assign string directly
    });
  }

  Future<void> _fetchTeachers() async {
    final teachersList = (await _teacherService.getAllTeachers())
        .map((teacher) => teacher['teacher'] as Teacher)
        .toList();
    setState(() {
      _allTeachers = teachersList;
      _teachers = teachersList;
    });
  }

  Future<void> _fetchSubjects() async {
    final subjectsList = await _subjectService.getAllSubjects();
    setState(() {
      _allSubjects = subjectsList;
      _subjects = subjectsList;
    });
  }

  Future<void> _fetchRooms() async {
    final roomsList = await _roomService.getAllRooms();
    setState(() {
      _rooms = roomsList;
    });
  }

  Future<void> _fetchClasses() async {
    final classesList = await _classService.getAllClasses();
    setState(() {
      _classes = classesList;
    });
  }

  void _refreshTeachers() {
    if (_selectedSubject != null) {
      setState(() {
        _teachers = _allTeachers.where((teacher) => teacher.subjects.contains(_selectedSubject!.id)).toList();
      });
    }
  }

  void _refreshSubjects() {
    if (_selectedTeacher != null) {
      setState(() {
        _subjects = _allSubjects.where((subject) => _selectedTeacher!.subjects.contains(subject.id)).toList();
      });
    }
  }

  void _saveActivity() async {
    if (_formIsValid()) {
      final updatedActivity = Activity(
        id: widget.activity['id'],
        subject: _selectedSubject!.id!,
        teacher: _selectedTeacher!.id!,
        studentsClass: _selectedClass!.id!,
        duration: int.parse(_durationController.text),
        tag: ActivityTag.values.firstWhere((e) => e.name == _selectedTag),
        room: _selectedRoom?.id ?? '',
        day: _selectedDay ?? '', // Provide a default value if null
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
      );

      final result = await ActivityService().updateActivity(widget.activity['id'], updatedActivity);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Activity updated successfully')));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating activity: ${result['message']}')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill out all fields and ensure the duration is at least 60 minutes.')));
    }
  }

  bool _formIsValid() {
    return _selectedSubject != null &&
        _selectedTeacher != null &&
        _selectedClass != null &&
        _selectedTag != null &&
        _durationController.text.isNotEmpty &&
        int.tryParse(_durationController.text) != null &&
        int.parse(_durationController.text) >= 60 &&
        _selectedDay != null &&
        _startTimeController.text.isNotEmpty &&
        _endTimeController.text.isNotEmpty;
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
              // Subject Dropdown
              activityDropdownMenu("subject", _selectedSubject, _subjects, (dynamic newValue) {
                setState(() {
                  _selectedSubject = newValue as Subject;
                  _refreshTeachers(); // Refresh teachers based on selected subject
                });
              }),
              const SizedBox(height: 16),

              // Teacher Dropdown
              activityDropdownMenu("teacher", _selectedTeacher, _teachers, (dynamic newValue) {
                setState(() {
                  _selectedTeacher = newValue as Teacher;
                  _refreshSubjects(); // Refresh subjects based on selected teacher
                });
              }),
              const SizedBox(height: 16),

              // Class Dropdown
              activityDropdownMenu("class", _selectedClass, _classes, (dynamic newValue) {
                setState(() {
                  _selectedClass = newValue as Class;
                });
              }),
              const SizedBox(height: 16),

              // Tag Dropdown
              activityDropdownMenu("tag", _selectedTag, _tags, (dynamic newValue) {
                setState(() {
                  _selectedTag = newValue as String;
                });
              }),
              const SizedBox(height: 16),

              // Room Dropdown
              activityDropdownMenu("room", _selectedRoom, _rooms, (dynamic newValue) {
                setState(() {
                  _selectedRoom = newValue as Room;
                });
              }),
              const SizedBox(height: 16),

              // Day Dropdown (using string list now)
              activityDropdownMenu("day", _selectedDay, _days, (dynamic newValue) {
                setState(() {
                  _selectedDay = newValue as String; // Set the selected day as string
                });
              }),
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

              // Start Time TextField
              TextField(
                controller: _startTimeController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Start Time (HH:mm)',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // End Time TextField
              TextField(
                controller: _endTimeController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'End Time (HH:mm)',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
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
