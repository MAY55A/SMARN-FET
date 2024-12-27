import 'package:flutter/material.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/models/room_type.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/services/constraint_service.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/services/class_service.dart';
import 'package:smarn/services/room_service.dart';
import 'package:smarn/services/subject_service.dart';

class EditSpaceConstraintView extends StatefulWidget {
  final SpaceConstraint constraint;

  const EditSpaceConstraintView({Key? key, required this.constraint})
      : super(key: key);

  @override
  _EditSpaceConstraintViewState createState() =>
      _EditSpaceConstraintViewState();
}

class _EditSpaceConstraintViewState extends State<EditSpaceConstraintView> {
  final ConstraintService _constraintService = ConstraintService();
  final TeacherService _teacherService = TeacherService();
  final ClassService _classService = ClassService();
  final RoomService _roomService = RoomService();
  final SubjectService _subjectService = SubjectService();

  final TextEditingController _idController = TextEditingController();

  ActivityTag? _selectedActivityType;
  String? _selectedRoomId;
  String? _selectedTeacherId;
  String? _selectedClassId;
  String? _selectedSubjectId;
  RoomType? _selectedRoomType;
  SpaceConstraintType? _selectedType;

  List<Map<String, dynamic>> _teachers = [];
  List<Class> _classes = [];
  List<Room> _rooms = [];
  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _idController.text = widget.constraint.id;
    _selectedActivityType = widget.constraint.activityType;
    _selectedRoomId = widget.constraint.roomId;
    _selectedTeacherId = widget.constraint.teacherId;
    _selectedClassId = widget.constraint.classId;
    _selectedSubjectId = widget.constraint.subjectId;
    _selectedRoomType = widget.constraint.requiredRoomType;
    _selectedType = widget.constraint.type;

    _fetchTeachers();
    _fetchClasses();
    _fetchRooms();
    _fetchSubjects();
  }

  Future<void> _fetchTeachers() async {
    List<Map<String, dynamic>> teachers =
        await _teacherService.getAllTeachers();
    setState(() {
      _teachers = teachers;
    });
  }

  Future<void> _fetchClasses() async {
    List<Class> classes = await _classService.getAllClasses();
    setState(() {
      _classes = classes;
    });
  }

  Future<void> _fetchRooms() async {
    List<Room> rooms = await _roomService.getAllRooms();
    setState(() {
      _rooms = rooms;
    });
  }

  Future<void> _fetchSubjects() async {
    List<Subject> subjects = await _subjectService.getAllSubjects();
    setState(() {
      _subjects = subjects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Space Constraint"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _idController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Constraint ID',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButton<SpaceConstraintType>(
                value: _selectedType,
                hint: const Text("Select Constraint Type",
                    style: TextStyle(color: Colors.white)),
                items: SpaceConstraintType.values.map((type) {
                  return DropdownMenuItem<SpaceConstraintType>(
                    value: type,
                    child: Text(type.name,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                    // Reset fields based on the selected type
                    if (_selectedType != SpaceConstraintType.roomType) {
                      _selectedActivityType = null;
                      _selectedRoomType = null;
                    }
                    if (_selectedType != SpaceConstraintType.preferredRoom) {
                      _selectedRoomId = null;
                      _selectedTeacherId = null;
                      _selectedClassId = null;
                      _selectedSubjectId = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),

              // Activity Type dropdown for roomType
              if (_selectedType == SpaceConstraintType.roomType)
                DropdownButton<ActivityTag>(
                  value: _selectedActivityType,
                  hint: const Text("Select Activity Type",
                      style: TextStyle(color: Colors.white)),
                  items: ActivityTag.values.map((activity) {
                    return DropdownMenuItem<ActivityTag>(
                      value: activity,
                      child: Text(activity.name,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedActivityType = value;
                    });
                  },
                ),
              const SizedBox(height: 16),

              // Room Type dropdown for roomType
              if (_selectedType == SpaceConstraintType.roomType)
                DropdownButton<RoomType?>(
                  value: _selectedRoomType,
                  hint: const Text("Select Room Type",
                      style: TextStyle(color: Colors.white)),
                  items: RoomType.values.map((roomType) {
                    return DropdownMenuItem<RoomType?>(
                      value: roomType,
                      child: Text(roomType.name,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRoomType = value;
                    });
                  },
                ),
              const SizedBox(height: 16),

              // Preferred Room fields: Room, Teacher, Class, Subject
              if (_selectedType == SpaceConstraintType.preferredRoom) ...[
                DropdownButton<String?>(
                  value: _selectedRoomId,
                  hint: const Text("Select Room", style: TextStyle(color: Colors.white)),
                  items: _rooms.isEmpty
                      ? [DropdownMenuItem<String?>(child: Text('Loading...'), value: null)]
                      : _rooms.map((room) {
                          return DropdownMenuItem<String?>(value: room.id, child: Text(room.name ?? 'Unknown', style: const TextStyle(color: Colors.white)));
                        }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRoomId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButton<String?>(
                  value: _selectedTeacherId,
                  hint: const Text("Select Teacher", style: TextStyle(color: Colors.white)),
                  items: _teachers.isEmpty
                      ? [DropdownMenuItem<String?>(child: Text('Loading...'), value: null)]
                      : _teachers.map((teacher) {
                          return DropdownMenuItem<String?>(value: teacher['id'], child: Text(teacher['teacher'].name ?? 'Unknown', style: const TextStyle(color: Colors.white)));
                        }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTeacherId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButton<String?>(
                  value: _selectedClassId,
                  hint: const Text("Select Class", style: TextStyle(color: Colors.white)),
                  items: _classes.isEmpty
                      ? [DropdownMenuItem<String?>(child: Text('Loading...'), value: null)]
                      : _classes.map((classItem) {
                          return DropdownMenuItem<String?>(value: classItem.id, child: Text(classItem.name, style: const TextStyle(color: Colors.white)));
                        }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedClassId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButton<String?>(
                  value: _selectedSubjectId,
                  hint: const Text("Select Subject", style: TextStyle(color: Colors.white)),
                  items: _subjects.isEmpty
                      ? [DropdownMenuItem<String?>(child: Text('Loading...'), value: null)]
                      : _subjects.map((subject) {
                          return DropdownMenuItem<String?>(value: subject.id, child: Text(subject.name, style: const TextStyle(color: Colors.white)));
                        }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubjectId = value;
                    });
                  },
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveConstraint,
                child: const Text('Save Constraint'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 129, 77, 139)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveConstraint() async {
    if (_idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a constraint ID.')));
      return;
    }

    if (_selectedRoomId == null ||
        _selectedTeacherId == null ||
        _selectedClassId == null ||
        _selectedSubjectId == null ||
        _selectedRoomType == null ||
        _selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields.')));
      return;
    }

    final updatedConstraint = SpaceConstraint(
      id: _idController.text,
      type: _selectedType!,
      activityType: _selectedActivityType,
      roomId: _selectedRoomId,
      teacherId: _selectedTeacherId,
      classId: _selectedClassId,
      subjectId: _selectedSubjectId,
      requiredRoomType: _selectedRoomType,
    );

    final result = await _constraintService.updateConstraint(
        _idController.text, updatedConstraint);
    if (result['success']) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }
}
