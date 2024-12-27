import 'package:flutter/material.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/models/work_day.dart';
import 'package:smarn/services/constraint_service.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/services/class_service.dart';
import 'package:smarn/services/room_service.dart';
import 'package:smarn/pages/widgets/multi_select_dialog.dart';

class EditTimeConstraintView extends StatefulWidget {
  final Constraint constraint;

  const EditTimeConstraintView({Key? key, required this.constraint}) : super(key: key);

  @override
  _EditTimeConstraintViewState createState() => _EditTimeConstraintViewState();
}

class _EditTimeConstraintViewState extends State<EditTimeConstraintView> {
  final ConstraintService _constraintService = ConstraintService();
  final TeacherService _teacherService = TeacherService();
  final ClassService _classService = ClassService();
  final RoomService _roomService = RoomService();

  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  TimeConstraintType? _selectedType;
  List<WorkDay> _selectedDays = [];
  String? _selectedTeacherId;
  String? _selectedClassId;
  String? _selectedRoomId;

  List<Map<String, dynamic>> _teachers = [];
  List<Class> _classes = [];
  List<Room> _rooms = [];

  @override
  void initState() {
    super.initState();
    _startTimeController = TextEditingController(text: (widget.constraint as TimeConstraint).startTime);
    _endTimeController = TextEditingController(text: (widget.constraint as TimeConstraint).endTime);
    _selectedType = (widget.constraint as TimeConstraint).type;
    _selectedTeacherId = (widget.constraint as TimeConstraint).teacherId;
    _selectedClassId = (widget.constraint as TimeConstraint).classId;
    _selectedRoomId = (widget.constraint as TimeConstraint).roomId;
    _selectedDays = (widget.constraint as TimeConstraint).availableDays;
    _fetchTeachers();
    _fetchClasses();
    _fetchRooms();
  }

  Future<void> _selectDays(BuildContext context) async {
    final selectedDays = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return MultiSelectDialog(
          items: WorkDay.values.map((day) => day.name).toList(),
          selectedItems: _selectedDays.map((day) => day.name).toList(),
        );
      },
    );

    if (selectedDays != null) {
      setState(() {
        _selectedDays = selectedDays
            .map((day) => WorkDay.values.firstWhere((e) => e.name == day))
            .toList();
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Time Constraint"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<TimeConstraintType>(
                value: _selectedType,
                hint: const Text("Select Constraint Type",
                    style: TextStyle(color: Colors.white)),
                items: TimeConstraintType.values.map((type) {
                  return DropdownMenuItem<TimeConstraintType>(
                    value: type,
                    child: Text(type.name,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _startTimeController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Start Time',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _endTimeController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'End Time',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _teachers.isEmpty
                  ? const CircularProgressIndicator()
                  : DropdownButton<String>(
                      value: _selectedTeacherId,
                      hint: const Text("Select Teacher",
                          style: TextStyle(color: Colors.white)),
                      items: _teachers.isNotEmpty
                          ? _teachers.map<DropdownMenuItem<String>>((teacher) {
                              return DropdownMenuItem<String>(
                                value: teacher['id'],
                                child: Text(teacher['teacher'].name ?? 'Unknown',
                                    style: const TextStyle(color: Colors.white)),
                              );
                            }).toList()
                          : [],
                      onChanged: (value) {
                        setState(() {
                          _selectedTeacherId = value;
                        });
                      },
                    ),
              const SizedBox(height: 16),
              _classes.isEmpty
                  ? const CircularProgressIndicator()
                  : DropdownButton<String>(
                      value: _selectedClassId,
                      hint: const Text("Select Class",
                          style: TextStyle(color: Colors.white)),
                      items: _classes.isNotEmpty
                          ? _classes.map<DropdownMenuItem<String>>((classItem) {
                              return DropdownMenuItem<String>(
                                value: classItem.id,
                                child: Text(classItem.name,
                                    style: const TextStyle(color: Colors.white)),
                              );
                            }).toList()
                          : [],
                      onChanged: (value) {
                        setState(() {
                          _selectedClassId = value;
                        });
                      },
                    ),
              const SizedBox(height: 16),
              _rooms.isEmpty
                  ? const CircularProgressIndicator()
                  : DropdownButton<String>(
                      value: _selectedRoomId,
                      hint: const Text("Select Room",
                          style: TextStyle(color: Colors.white)),
                      items: _rooms.isNotEmpty
                          ? _rooms.map<DropdownMenuItem<String>>((room) {
                              return DropdownMenuItem<String>(
                                value: room.id,
                                child: Text(room.name ?? 'Unknown',
                                    style: const TextStyle(color: Colors.white)),
                              );
                            }).toList()
                          : [],
                      onChanged: (value) {
                        setState(() {
                          _selectedRoomId = value;
                        });
                      },
                    ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDays(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Available Days: ${_selectedDays.map((e) => e.name).join(', ')}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _editConstraint,
                child: const Text('Save Changes'),
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

  void _editConstraint() async {
    final updatedConstraint = TimeConstraint(
      id: widget.constraint.id,
      type: _selectedType ?? TimeConstraintType.classAvailability,
      startTime: _startTimeController.text,
      endTime: _endTimeController.text,
      availableDays: _selectedDays.isNotEmpty ? _selectedDays : [WorkDay.Monday],
      teacherId: _selectedTeacherId ?? 'default_teacher_id',
      classId: _selectedClassId ?? 'default_class_id',
      roomId: _selectedRoomId ?? 'default_room_id',
    );

    final result = await _constraintService.updateConstraint(widget.constraint.id, updatedConstraint);
    if (result['success']) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }
}
