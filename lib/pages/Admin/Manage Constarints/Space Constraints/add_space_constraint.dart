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

class AddSpaceConstraintView extends StatefulWidget {
  const AddSpaceConstraintView({Key? key}) : super(key: key);

  @override
  _AddSpaceConstraintViewState createState() => _AddSpaceConstraintViewState();
}

class _AddSpaceConstraintViewState extends State<AddSpaceConstraintView> {
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
  SpaceConstraintType? _selectedType;
  String? _selectedOption;

  List<Map<String, dynamic>> _teachers = [];
  List<Class> _classes = [];
  List<Room> _rooms = [];
  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
    _fetchClasses();
    _fetchRooms();
    _fetchSubjects();
  }

  Future<void> _fetchTeachers() async {
    List<Map<String, dynamic>> teachers = await _teacherService.getAllTeachers();
    setState(() {
      _teachers = teachers;
      _selectedTeacherId = teachers.isNotEmpty ? teachers[0]['id'] : null;
    });
  }

  Future<void> _fetchClasses() async {
    List<Class> classes = await _classService.getAllClasses();
    setState(() {
      _classes = classes;
      _selectedClassId = classes.isNotEmpty ? classes[0].id : null;
    });
  }

  Future<void> _fetchRooms() async {
    List<Room> rooms = await _roomService.getAllRooms();
    setState(() {
      _rooms = rooms;
      _selectedRoomId = rooms.isNotEmpty ? rooms[0].id : null;
    });
  }

  Future<void> _fetchSubjects() async {
    List<Subject> subjects = await _subjectService.getAllSubjects();
    setState(() {
      _subjects = subjects;
      _selectedSubjectId = subjects.isNotEmpty ? subjects[0].id : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Add Space Constraint"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Center(
        child: Container(
          width: 600,
          child: Card(
            color: Colors.grey[850],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Room Dropdown always visible
                    DropdownButton<String?>( 
                      value: _selectedRoomId,
                      hint: const Text("Select Room", style: TextStyle(color: Colors.white)),
                      items: _rooms.isEmpty
                          ? [const DropdownMenuItem<String?>(child: Text('Loading...'), value: null)]
                          : _rooms.map((room) {
                              return DropdownMenuItem<String?>( 
                                value: room.id,
                                child: Text(room.name, style: const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRoomId = value;
                        });
                      },
                      dropdownColor: Colors.grey[800],
                    ),

                    const SizedBox(height: 16),
                    DropdownButton<SpaceConstraintType>( 
                      value: _selectedType,
                      hint: const Text("Select Constraint Type", style: TextStyle(color: Colors.white)),
                      items: SpaceConstraintType.values.map((type) {
                        return DropdownMenuItem<SpaceConstraintType>(
                          value: type,
                          child: Text(type.name, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                          // Reset fields when type changes
                          _selectedTeacherId = null;
                          _selectedClassId = null;
                          _selectedSubjectId = null;
                          _selectedRoomType = null;
                          _selectedActivityType = null;
                          _selectedOption = null; // Reset selected option
                        });
                      },
                      dropdownColor: Colors.grey[800],
                    ),
                    const SizedBox(height: 16),

                    // Show Activity Type dropdown only if RoomType is selected
                    if (_selectedType == SpaceConstraintType.roomType)
                      DropdownButton<ActivityTag>( 
                        value: _selectedActivityType,
                        hint: const Text("Select Activity Type", style: TextStyle(color: Colors.white)),
                        items: ActivityTag.values.map((activity) {
                          return DropdownMenuItem<ActivityTag>(
                            value: activity,
                            child: Text(activity.name, style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedActivityType = value;
                          });
                        },
                        dropdownColor: Colors.grey[800],
                      ),
                    const SizedBox(height: 16),

                    // Show Room Type fields only if RoomType is selected
                    if (_selectedType == SpaceConstraintType.roomType) ...[ 
                      DropdownButton<RoomType?>( 
                        value: _selectedRoomType,
                        hint: const Text("Select Room Type", style: TextStyle(color: Colors.white)),
                        items: RoomType.values.map((roomType) {
                          return DropdownMenuItem<RoomType?>( 
                            value: roomType,
                            child: Text(roomType.name, style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRoomType = value;
                          });
                        },
                        dropdownColor: Colors.grey[800],
                      ),
                    ],

                    // Show Radio Buttons for Teacher, Class, and Subject if PreferredRoom is selected
                    if (_selectedType == SpaceConstraintType.preferredRoom) ...[
                      const SizedBox(height: 16),
                      Text("Select Option:", style: TextStyle(color: Colors.white)),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'teacher',
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value;
                                // Reset other selections when an option is selected
                                _selectedClassId = null;
                                _selectedSubjectId = null;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 129, 77, 139),
                          ),
                          const Text('Teacher', style: TextStyle(color: Colors.white)),
                          Radio<String>(
                            value: 'class',
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value;
                                // Reset other selections when an option is selected
                                _selectedTeacherId = null;
                                _selectedSubjectId = null;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 129, 77, 139),
                          ),
                          const Text('Class', style: TextStyle(color: Colors.white)),
                          Radio<String>(
                            value: 'subject',
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value;
                                // Reset other selections when an option is selected
                                _selectedTeacherId = null;
                                _selectedClassId = null;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 129, 77, 139),
                          ),
                          const Text('Subject', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Show corresponding dropdown based on selected option
                    if (_selectedOption == 'teacher') ...[
                      DropdownButton<String?>( 
                        value: _selectedTeacherId,
                        hint: const Text("Select Teacher", style: TextStyle(color: Colors.white)),
                        items: _teachers.isEmpty
                            ? [const DropdownMenuItem<String?>(child: Text('Loading...'), value: null)]
                            : _teachers.map((teacher) {
                                return DropdownMenuItem<String?>( 
                                  value: teacher['teacher'].id,
                                  child: Text(teacher['teacher'].name ?? 'Unknown', style: const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTeacherId = value;
                          });
                        },
                        dropdownColor: Colors.grey[800],
                      ),
                    ] else if (_selectedOption == 'class') ...[
                      DropdownButton<String?>( 
                        value: _selectedClassId,
                        hint: const Text("Select Class", style: TextStyle(color: Colors.white)),
                        items: _classes.isEmpty
                            ? [const DropdownMenuItem<String?>(child: Text('Loading...'), value: null)]
                            : _classes.map((classItem) {
                                return DropdownMenuItem<String?>( 
                                  value: classItem.id,
                                  child: Text(classItem.name, style: const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedClassId = value;
                          });
                        },
                        dropdownColor: Colors.grey[800],
                      ),
                    ] else if (_selectedOption == 'subject') ...[
                      DropdownButton<String?>( 
                        value: _selectedSubjectId,
                        hint: const Text("Select Subject", style: TextStyle(color: Colors.white)),
                        items: _subjects.isEmpty
                            ? [const DropdownMenuItem<String?>(child: Text('Loading...'), value: null)]
                            : _subjects.map((subject) {
                                return DropdownMenuItem<String?>( 
                                  value: subject.id,
                                  child: Text(subject.name, style: const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSubjectId = value;
                          });
                        },
                        dropdownColor: Colors.grey[800],
                      ),
                    ],

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveConstraint,
                      child: const Text('Save Constraint'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 129, 77, 139)),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
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

 void _saveConstraint() async {
  if (_selectedType == null) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a constraint type.')));
    return;
  }

  // Validation for 'roomType' constraint
  if (_selectedType == SpaceConstraintType.roomType && _selectedRoomType == null) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a room type.')));
    return;
  }

  // Validation for 'preferredRoom' constraint
  if (_selectedType == SpaceConstraintType.preferredRoom) {
    if (_selectedRoomId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a room.')));
      return;
    }
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an option (Teacher, Class, or Subject).')));
      return;
    }

    // Validate based on the selected option
    if (_selectedOption == 'teacher' && _selectedTeacherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a teacher.')));
      return;
    }
    if (_selectedOption == 'class' && _selectedClassId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a class.')));
      return;
    }
    if (_selectedOption == 'subject' && _selectedSubjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a subject.')));
      return;
    }
  }

  // Confirm before saving
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[850], // Gray background for alert
        title: const Text("Confirm Constraint Addition", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure you want to save this constraint?", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );

  if (confirm != true) return;

  final newConstraint = SpaceConstraint(
    id: '',
    type: _selectedType!,
    activityType: _selectedActivityType,
    roomId: _selectedRoomId,
    teacherId: _selectedTeacherId,
    classId: _selectedClassId,
    subjectId: _selectedSubjectId,
    requiredRoomType: _selectedRoomType,
  );

  final result = await _constraintService.createSpaceConstraint(newConstraint);
  if (result['success']) {
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result['message'])));
  }
}

}
