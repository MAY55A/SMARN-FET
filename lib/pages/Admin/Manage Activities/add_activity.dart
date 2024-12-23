import 'package:flutter/material.dart';
import 'package:smarn/models/activity.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/pages/widgets/dropDownMenu.dart';
import 'package:smarn/services/class_service.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/services/subject_service.dart';
import 'package:smarn/services/activity_service.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({Key? key}) : super(key: key);

  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  final List<String> _tags = ActivityTag.values.map((t) => t.name).toList();

  Class? _selectedClass;
  String? _selectedTag;
  Teacher? _selectedTeacher;
  Subject? _selectedSubject;

  List<Class> _classes = [];
  List<Teacher> _allTeachers = [];
  List<Subject> _allSubjects = [];
  List<Teacher> _teachers = [];
  List<Subject> _subjects = [];

  final TeacherService _teacherService = TeacherService();
  final SubjectService _subjectService = SubjectService();
  final ClassService _classService = ClassService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.wait([
      _fetchTeachers(),
      _fetchSubjects(),
      _fetchClasses(),
    ]);
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

  Future<void> _fetchClasses() async {
    final classesList = await _classService.getAllClasses();
    setState(() {
      _classes = classesList;
    });
  }

  void _saveActivity() {
    if (_formIsValid()) {
      final activity = Activity(
        subject: _selectedSubject!.id!,
        teacher: _selectedTeacher!.id!,
        studentsClass: _selectedClass!.id!,
        duration: int.parse(_durationController.text),
        tag: ActivityTag.values.firstWhere((e) => e.name == _selectedTag),
        isActive: true,
      );

      // Add the activity using the service
      ActivityService().addActivity(activity).then((result) {
        if (result['success']) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding activity: ${result['message']}')),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields and ensure the duration is at least 60 minutes.')),
      );
    }
  }

  bool _formIsValid() {
    return _selectedSubject != null &&
        _selectedTeacher != null &&
        _selectedClass != null &&
        _selectedTag != null &&
        _durationController.text.isNotEmpty &&
        int.tryParse(_durationController.text) != null &&
        int.parse(_durationController.text) >= 60;
  }

  void _refreshSubjects() {
    // Assuming this method filters subjects based on selected teacher
    if (_selectedTeacher != null) {
      setState(() {
        _subjects = _allSubjects; // No filtering needed, as teachers are not linked to subjects
      });
    }
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
              // Subject Dropdown
              activityDropdownMenu("subject", _selectedSubject, _subjects, (dynamic newValue) {
                setState(() {
                  _selectedSubject = newValue as Subject;
                });
              }),
              const SizedBox(height: 16),

              // Teacher Dropdown
              activityDropdownMenu("teacher", _selectedTeacher, _teachers, (dynamic newValue) {
                setState(() {
                  _selectedTeacher = newValue as Teacher;
                  _refreshSubjects(); // Reset subjects to show all
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
