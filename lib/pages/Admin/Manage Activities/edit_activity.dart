import 'package:flutter/material.dart';
import 'package:smarn/models/activity.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/pages/widgets/dropDownMenu.dart';
import 'package:smarn/pages/widgets/duration_form_field.dart';
import 'package:smarn/services/class_service.dart';
import 'package:smarn/services/constraint_service.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/services/subject_service.dart';
import 'package:smarn/services/activity_service.dart';

class EditActivity extends StatefulWidget {
  final Map<String, dynamic> activity;

  const EditActivity({Key? key, required this.activity}) : super(key: key);

  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  final List<String> _tags = ActivityTag.values.map((a) => a.name).toList();

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

  late Activity _oldActivity;

  bool _isLoading = true;
  bool _isActive = true; // New field for active state

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    await Future.wait([
      _fetchDurations(),
      _fetchTeachers(),
      _fetchSubjects(),
      _fetchClasses(),
    ]);

    // Pre-fill fields with existing data
    setState(() {
      _duration = widget.activity['duration'];
      _selectedClass = _classes
          .firstWhere((c) => c.id == widget.activity['studentsClass']['id']);
      _selectedTag = widget.activity['tag'];
      _selectedTeacher = _allTeachers
          .firstWhere((t) => t.id == widget.activity['teacher']['id']);
      _selectedSubject = _allSubjects
          .firstWhere((s) => s.id == widget.activity['subject']['id']);
      _isActive = widget.activity['isActive']; // Set initial active state
      _oldActivity = fillActivity();
      _isLoading = false;
    });
  }

  Activity fillActivity() {
    return Activity(
        id: widget.activity['id'],
        subject: _selectedSubject!.id!,
        teacher: _selectedTeacher!.id!,
        studentsClass: _selectedClass!.id!,
        duration: _duration!,
        tag: ActivityTag.values.firstWhere((t) => t.name == _selectedTag),
        isActive: _isActive); // Include active state
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

  void _refreshTeachers() {
    setState(() {
      _teachers = _allTeachers
          .where((teacher) => teacher.subjects.contains(_selectedSubject!.id))
          .toList();
      if (!_teachers.contains(_selectedTeacher)) {
        _selectedTeacher = null;
      }
    });
  }

  void _refreshSubjects() {
    setState(() {
      _subjects = _allSubjects
          .where((subject) => _selectedTeacher!.subjects.contains(subject.id))
          .toList();
    });
  }

  void _saveActivity() async {
    if (_formIsValid()) {
      final updatedActivity = fillActivity();
      if (_oldActivity.equals(updatedActivity)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No changes were made to the activity')),
        );
      } else {
        final result = await ActivityService()
            .updateActivity(widget.activity['id'], updatedActivity);

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Activity updated successfully')));
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error updating activity: ${result['message']}')));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill out all fields.')));
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
        title: const Text('Edit Activity'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400, // Set a maximum width for the form
                ),
                child: Card(
                  color: const Color.fromARGB(255, 34, 34, 34),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Subject Dropdown
                          activityDropdownMenu(
                              "subject", _selectedSubject, _subjects,
                              (dynamic newValue) {
                            setState(() {
                              _selectedSubject = newValue as Subject;
                              _refreshTeachers(); // Refresh teachers based on selected subject
                            });
                          }),
                          const SizedBox(height: 16),

                          // Teacher Dropdown
                          activityDropdownMenu(
                              "teacher", _selectedTeacher, _teachers,
                              (dynamic newValue) {
                            setState(() {
                              _selectedTeacher = newValue as Teacher;
                              //_refreshSubjects(); // Refresh subjects based on selected teacher
                            });
                          }),
                          const SizedBox(height: 16),

                          // Class Dropdown
                          activityDropdownMenu(
                              "class", _selectedClass, _classes,
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
                          }, _duration),
                          // Active Toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Active',
                                style: TextStyle(color: Colors.white),
                              ),
                              Switch(
                                value: _isActive,
                                onChanged: (value) {
                                  setState(() {
                                    _isActive = value;
                                  });
                                },
                                activeColor:
                                    const Color.fromARGB(255, 129, 77, 139),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Save Button
                          ElevatedButton(
                            onPressed: _saveActivity,
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 129, 77, 139)),
                            ),
                            child: const Text('Save Activity'),
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
