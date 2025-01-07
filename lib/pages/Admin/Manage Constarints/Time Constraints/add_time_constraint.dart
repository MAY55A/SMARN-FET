import 'package:flutter/material.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/models/work_day.dart';
import 'package:smarn/pages/widgets/duration_form_field.dart';
import 'package:smarn/services/constraint_service.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/services/class_service.dart';
import 'package:smarn/services/room_service.dart';
import 'package:smarn/pages/widgets/multi_select_dialog.dart';
import 'package:smarn/services/time_service.dart';

class AddTimeConstraintView extends StatefulWidget {
  const AddTimeConstraintView({Key? key}) : super(key: key);

  @override
  _AddTimeConstraintViewState createState() => _AddTimeConstraintViewState();
}

class _AddTimeConstraintViewState extends State<AddTimeConstraintView> {
  final ConstraintService _constraintService = ConstraintService();
  final TeacherService _teacherService = TeacherService();
  final ClassService _classService = ClassService();
  final RoomService _roomService = RoomService();

  String? _selectedStartTime;
  String? _selectedEndTime;
  TimeConstraintType? _selectedType;
  List<WorkDay> _selectedDays = [];
  String? _selectedId;

  List<Map<String, dynamic>> _teachers = [];
  List<Class> _classes = [];
  List<Room> _rooms = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Add Time Constraint"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Center(
        child: SizedBox(
          width: 600,
          child: Card(
            color: Colors.grey[900],
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
                          _selectedId = null;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: Colors.grey[800],
                    ),
                    const SizedBox(height: 16),
                    // Start time field
                    durationFormField(
                      "Start Time",
                      TimeService.timeToMinutes("08:00"),
                      60,
                      TimeService.timeToMinutes("20:00"),
                      (time) {
                        setState(() {
                          _selectedStartTime = TimeService.minutesToTime(time!);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // End time field
                    durationFormField(
                      "End Time",
                      TimeService.timeToMinutes("08:00"),
                      60,
                      TimeService.timeToMinutes("20:00"),
                      (time) {
                        setState(() {
                          _selectedEndTime = TimeService.minutesToTime(time!);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Select Available Days
                    GestureDetector(
                      onTap: () => _selectDays(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDays.isEmpty
                                  ? "Select available Days"
                                  : _selectedDays
                                      .map((e) => e.name.substring(0, 3))
                                      .join(', '),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Conditionally show fields based on selected type
                    if (_selectedType == TimeConstraintType.teacherAvailability)
                      _teachers.isEmpty
                          ? const CircularProgressIndicator()
                          : DropdownButton<String>(
                              value: _selectedId,
                              hint: const Text("Select Teacher",
                                  style: TextStyle(color: Colors.white)),
                              items: _teachers.isNotEmpty
                                  ? _teachers
                                      .map<DropdownMenuItem<String>>((teacher) {
                                      return DropdownMenuItem<String>(
                                        value: teacher['teacher']?.id,
                                        child: Text(
                                            teacher['teacher']?.name ??
                                                'Unknown',
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      );
                                    }).toList()
                                  : [],
                              onChanged: (value) {
                                setState(() {
                                  _selectedId = value;
                                });
                              },
                              style: const TextStyle(color: Colors.white),
                              dropdownColor: Colors.grey[800],
                            ),
                    if (_selectedType == TimeConstraintType.classAvailability)
                      _classes.isEmpty
                          ? const CircularProgressIndicator()
                          : DropdownButton<String>(
                              value: _selectedId,
                              hint: const Text("Select Class",
                                  style: TextStyle(color: Colors.white)),
                              items: _classes.isNotEmpty
                                  ? _classes.map<DropdownMenuItem<String>>(
                                      (classItem) {
                                      return DropdownMenuItem<String>(
                                        value: classItem.id,
                                        child: Text(classItem.id!,
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      );
                                    }).toList()
                                  : [],
                              onChanged: (value) {
                                setState(() {
                                  _selectedId = value;
                                });
                              },
                              style: const TextStyle(color: Colors.white),
                              dropdownColor: Colors.grey[800],
                            ),
                    if (_selectedType == TimeConstraintType.roomAvailability)
                      _rooms.isEmpty
                          ? const CircularProgressIndicator()
                          : DropdownButton<String>(
                              value: _selectedId,
                              hint: const Text("Select Room",
                                  style: TextStyle(color: Colors.white)),
                              items: _rooms.isNotEmpty
                                  ? _rooms
                                      .map<DropdownMenuItem<String>>((room) {
                                      return DropdownMenuItem<String>(
                                        value: room.id,
                                        child: Text(room.name ?? 'Unknown',
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      );
                                    }).toList()
                                  : [],
                              onChanged: (value) {
                                setState(() {
                                  _selectedId = value;
                                });
                              },
                              style: const TextStyle(color: Colors.white),
                              dropdownColor: Colors.grey[800],
                            ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addConstraint,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 129, 77, 139)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Add Constraint'),
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

  Future<void> _addConstraint() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a constraint type.')),
      );
      return;
    }

    if (_selectedStartTime == null || _selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose start and end times.')),
      );
      return;
    }

    if (TimeService.timeToMinutes(_selectedStartTime!) >=
        TimeService.timeToMinutes(_selectedEndTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start time must be less than end time.')),
      );
      return;
    }

    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day.')),
      );
      return;
    }

    if (_selectedId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Please select a ${_selectedType!.name.substring(0, _selectedType!.name.length - 8)}.')));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800], // Set background color to gray
          title: const Text(
            "Confirm Constraint Addition",
            style: TextStyle(color: Colors.white), // White title text
          ),
          content: const Text(
            "Are you sure you want to add this constraint?",
            style: TextStyle(color: Colors.white), // White content text
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child:
                  const Text("Confirm", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
    });

    final newConstraint = TimeConstraint(
      type: _selectedType!,
      startTime: _selectedStartTime,
      endTime: _selectedEndTime,
      availableDays: _selectedDays,
      teacherId: _selectedType == TimeConstraintType.teacherAvailability
          ? _selectedId
          : null,
      classId: _selectedType == TimeConstraintType.classAvailability
          ? _selectedId
          : null,
      roomId: _selectedType == TimeConstraintType.roomAvailability
          ? _selectedId
          : null,
    );

    final result = await _constraintService.createTimeConstraint(newConstraint);

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Constraint added successfully.')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }
}
