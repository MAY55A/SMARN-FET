import 'package:flutter/material.dart';
import 'package:smarn/models/activity.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/pages/Admin/Manage%20Activities/manage_activities_form.dart';
import 'package:smarn/pages/widgets/dropDownMenu.dart';
import 'package:smarn/pages/widgets/duration_form_field.dart';
import 'package:smarn/services/class_service.dart';
import 'package:smarn/services/constraint_service.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/services/subject_service.dart';
import 'package:smarn/services/activity_service.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({Key? key}) : super(key: key);

  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final List<String> _tags = ActivityTag.values.map((t) => t.name).toList();

  Class? _selectedClass;
  String? _selectedTag;
  Teacher? _selectedTeacher;
  Subject? _selectedSubject;
  int? _duration;

  List<Class> _classes = [];
  List<Teacher> _allTeachers = [];
  List<Subject> _allSubjects = [];
  List<Teacher> _teachers = [];
  List<Subject> _subjects = [];

  final TeacherService _teacherService = TeacherService();
  final SubjectService _subjectService = SubjectService();
  final ClassService _classService = ClassService();
  final ConstraintService _constraintService = ConstraintService();

  int _minDuration = 60;
  int _maxDuration = 240;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.wait([
      _fetchDurations(),
      _fetchTeachers(), // Récupérer tous les enseignants ici
      _fetchSubjects(),
      _fetchClasses(),
    ]);
  }

  Future<void> _fetchDurations() async {
    final min = (await _constraintService.getMinMaxDuration('min'));
    final max = (await _constraintService.getMinMaxDuration('max'));
    setState(() {
      if (min != null) {
        _minDuration = min;
      }
      if (max != null) {
        _maxDuration = max;
      }
    });
  }

  Future<void> _fetchTeachers() async {
    final teachersList = await _teacherService
        .getAllTeachers(); // Récupérer tous les enseignants
    setState(() {
      _allTeachers =
          teachersList.map((item) => item['teacher'] as Teacher).toList();
      _teachers = _allTeachers; // Initialiser la liste des enseignants
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

  Future<void> _refreshTeachers() async {
    final teachersList = _allTeachers
        .where((teacher) => teacher.subjects.contains(_selectedSubject!.id))
        .toList();
    setState(() {
      _teachers = teachersList;
      if (!_teachers.contains(_selectedTeacher)) {
        _selectedTeacher = null;
      }
    });
  }

  Future<void> _refreshSubjects() async {
    final subjectsList = _allSubjects
        .where((s) => _selectedTeacher!.subjects.contains(s.id))
        .toList();
    setState(() {
      _subjects = subjectsList;
    });
  }

  void _saveActivity() {
    if (_formIsValid()) {
      final activity = Activity(
        subject: _selectedSubject!.id!,
        teacher: _selectedTeacher!.id!,
        studentsClass: _selectedClass!.id!,
        duration: _duration!,
        tag: ActivityTag.values.firstWhere((e) => e.name == _selectedTag),
      );

      // Add the activity using the service
      ActivityService().addActivity(activity).then((result) {
        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Activity added successfully')));
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
    }
  }

  bool _formIsValid() {
    return _selectedSubject != null &&
        _selectedTeacher != null &&
        _selectedClass != null &&
        _selectedTag != null &&
        _duration != null;
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
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400, // Set a maximum width for the form
          ),
          child: Card(
            color: const Color.fromARGB(255, 34, 34, 34),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Subject Dropdown
                    activityDropdownMenu("subject", _selectedSubject, _subjects,
                        (dynamic newValue) {
                      setState(() {
                        _selectedSubject = newValue as Subject;
                        _refreshTeachers();
                      });
                    }),
                    const SizedBox(height: 16),

                    // Teacher Dropdown
                    activityDropdownMenu("teacher", _selectedTeacher, _teachers,
                        (dynamic newValue) {
                      setState(() {
                        _selectedTeacher = newValue as Teacher;
                      });
                    }),
                    const SizedBox(height: 16),

                    // Class Dropdown
                    activityDropdownMenu("class", _selectedClass, _classes,
                        (dynamic newValue) {
                      setState(() {
                        _selectedClass = newValue as Class;
                      });
                    }),
                    const SizedBox(height: 16),

                    // Tag Dropdown
                    activityDropdownMenu("tag", _selectedTag, _tags,
                        (dynamic newValue) {
                      setState(() {
                        _selectedTag = newValue as String;
                      });
                    }),
                    const SizedBox(height: 16),

                    // Duration TextField
                    durationFormField(
                        "Duration", // Field label
                        _minDuration, // Minimum duration in minutes
                        _minDuration,
                        _maxDuration, // Maximum duration in minutes
                        (value) {
                      setState(() {
                        _duration = value;
                      });
                    }),
                    const SizedBox(height: 16),

                    // Save Button
                    ElevatedButton(
                      onPressed: _saveActivity,
                      child: const Text('Save Activity'),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 129, 77, 139)),
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
