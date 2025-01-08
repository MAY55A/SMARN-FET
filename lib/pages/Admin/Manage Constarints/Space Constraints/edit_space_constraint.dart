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

  ActivityTag? _selectedActivityType;
  String? _selectedRoomId;
  String? _selectedTeacherId;
  String? _selectedClassId;
  String? _selectedSubjectId;
  RoomType? _selectedRoomType;
  bool _isActive = true;

  List<Map<String, dynamic>> _teachers = [];
  List<Class> _classes = [];
  List<Room> _rooms = [];
  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _selectedActivityType = widget.constraint.activityType;
    _selectedRoomId = widget.constraint.roomId;
    _selectedTeacherId = widget.constraint.teacherId;
    _selectedClassId = widget.constraint.classId;
    _selectedSubjectId = widget.constraint.subjectId;
    _selectedRoomType = widget.constraint.requiredRoomType;
    _isActive = widget.constraint.isActive;

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Edit Space Constraint"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Center(
        child: Container(
          width: 800,
          height: 600,
          child: Card(
            color: Colors.grey[850],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.constraint.type.name,
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 16),

                  // Activity Type dropdown for roomType
                  if (widget.constraint.type == SpaceConstraintType.roomType)
                    DropdownButton<ActivityTag>(
                      value: _selectedActivityType,
                      hint: const Text(
                        "Select Activity Type",
                        style: TextStyle(color: Colors.white),
                      ),
                      items: ActivityTag.values.map((activity) {
                        return DropdownMenuItem<ActivityTag>(
                          value: activity,
                          child: Text(
                            activity.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedActivityType = value;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: Colors.grey[800],
                    ),
                  const SizedBox(height: 16),

                  // Room Type dropdown for roomType
                  if (widget.constraint.type == SpaceConstraintType.roomType)
                    DropdownButton<RoomType?>(
                      value: _selectedRoomType,
                      hint: const Text(
                        "Select Room Type",
                        style: TextStyle(color: Colors.white),
                      ),
                      items: RoomType.values.map((roomType) {
                        return DropdownMenuItem<RoomType?>(
                          value: roomType,
                          child: Text(
                            roomType.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRoomType = value;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: Colors.grey[800],
                    ),
                  const SizedBox(height: 16),

                  // Preferred Room fields: Room, Teacher, Class, Subject
                  if (widget.constraint.type == SpaceConstraintType.preferredRoom) ...[
                    DropdownButton<String?>(
                      value: _selectedRoomId,
                      hint: const Text(
                        "Select Room",
                        style: TextStyle(color: Colors.white),
                      ),
                      items: _rooms.map((room) {
                        return DropdownMenuItem<String?>(
                          value: room.id,
                          child: Text(
                            room.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toSet().toList(), // Remove duplicates
                      onChanged: (value) {
                        setState(() {
                          _selectedRoomId = value;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: Colors.grey[800],
                    ),
                    const SizedBox(height: 16),
                    DropdownButton<String?>(
                      value: _selectedTeacherId,
                      hint: const Text(
                        "Select Teacher",
                        style: TextStyle(color: Colors.white),
                      ),
                      items: _teachers.map((teacher) {
                        return DropdownMenuItem<String?>(
                          value: teacher['id'],
                          child: Text(
                            teacher['teacher'].name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toSet().toList(), // Remove duplicates
                      onChanged: (value) {
                        setState(() {
                          _selectedTeacherId = value;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: Colors.grey[800],
                    ),
                    const SizedBox(height: 16),
                    DropdownButton<String?>(
                      value: _selectedClassId,
                      hint: const Text(
                        "Select Class",
                        style: TextStyle(color: Colors.white),
                      ),
                      items: _classes.map((classItem) {
                        return DropdownMenuItem<String?>(
                          value: classItem.id,
                          child: Text(
                            classItem.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toSet().toList(), // Remove duplicates
                      onChanged: (value) {
                        setState(() {
                          _selectedClassId = value;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: Colors.grey[800],
                    ),
                    const SizedBox(height: 16),
                    DropdownButton<String?>(
                      value: _selectedSubjectId,
                      hint: const Text(
                        "Select Subject",
                        style: TextStyle(color: Colors.white),
                      ),
                      items: _subjects.map((subject) {
                        return DropdownMenuItem<String?>(
                          value: subject.id,
                          child: Text(
                            subject.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toSet().toList(), // Remove duplicates
                      onChanged: (value) {
                        setState(() {
                          _selectedSubjectId = value;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: Colors.grey[800],
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Activation Toggle at the end
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Active:',
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                        activeColor: const Color.fromARGB(255, 129, 77, 139),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _saveConstraint,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 129, 77, 139)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: const Text('Save Constraint'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

   void _saveConstraint() {
    SpaceConstraint updatedConstraint = SpaceConstraint(
      id: widget.constraint.id,
      type: widget.constraint.type,
      activityType: _selectedActivityType,
      roomId: _selectedRoomId,
      teacherId: _selectedTeacherId,
      classId: _selectedClassId,
      subjectId: _selectedSubjectId,
      requiredRoomType: _selectedRoomType,
      isActive: _isActive, // Include active state in the updated constraint
    );
    if (widget.constraint.equals(updatedConstraint)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No changes were made to the constraint'),
      ));
    } else {
      _constraintService
          .updateConstraint(widget.constraint.id!, updatedConstraint)
          .then((response) {
        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Constraint updated successfully!')),
          );
          Navigator.pop(context);
        } else {
          String errorMessage =
              response['message'] ?? 'Failed to update constraint.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred.')),
        );
      });
    }
  }
}
