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

class EditTimeConstraintView extends StatefulWidget {
  final TimeConstraint constraint;

  const EditTimeConstraintView({Key? key, required this.constraint})
      : super(key: key);

  @override
  _EditTimeConstraintViewState createState() => _EditTimeConstraintViewState();
}

class _EditTimeConstraintViewState extends State<EditTimeConstraintView> {
  final ConstraintService _constraintService = ConstraintService();
  final TeacherService _teacherService = TeacherService();
  final ClassService _classService = ClassService();
  final RoomService _roomService = RoomService();

  String? _selectedStartTime;
  String? _selectedEndTime;
  List<WorkDay> _selectedDays = [];
  String? _selectedId;
  bool _isActive = true; // Active toggle state

  List<Map<String, dynamic>> _teachers = [];
  List<Class> _classes = [];
  List<Room> _rooms = [];

  @override
  void initState() {
    super.initState();

    _selectedStartTime = widget.constraint.startTime;
    _selectedEndTime = widget.constraint.endTime;
    _selectedId = widget.constraint.teacherId ??
        widget.constraint.classId ??
        widget.constraint.roomId;
    _selectedDays = widget.constraint.availableDays;
    _isActive = widget.constraint.isActive; // Initialize active state

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
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text("Edit Time Constraint"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
              maxWidth: 600), // Limiter la largeur du formulaire
          padding: const EdgeInsets.all(16.0),
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
                    Text(widget.constraint.type.name,
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 16),
                    durationFormField(
                        "Start Time",
                        TimeService.timeToMinutes("08:00"),
                        60,
                        TimeService.timeToMinutes("20:00"), (time) {
                      setState(() {
                        _selectedStartTime = TimeService.minutesToTime(time!);
                      });
                    }, TimeService.timeToMinutes(_selectedStartTime!)),
                    const SizedBox(height: 16),
                    durationFormField(
                        "End Time",
                        TimeService.timeToMinutes("08:00"),
                        60,
                        TimeService.timeToMinutes("20:00"), (time) {
                      setState(() {
                        _selectedEndTime = TimeService.minutesToTime(time!);
                      });
                    }, TimeService.timeToMinutes(_selectedEndTime!)),
                    const SizedBox(height: 16),
                    if (widget.constraint.type ==
                        TimeConstraintType.teacherAvailability)
                      _teachers.isEmpty
                          ? const CircularProgressIndicator()
                          : DropdownButton<String>(
                              value: _selectedId,
                              hint: const Text("Select Teacher",
                                  style: TextStyle(color: Colors.white)),
                              items: _teachers
                                  .map<DropdownMenuItem<String>>((teacher) {
                                return DropdownMenuItem<String>(
                                  value: teacher['id'],
                                  child: Text(
                                      teacher['teacher'].name ?? 'Unknown',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedId = value;
                                });
                              },
                              style: const TextStyle(color: Colors.white),
                              dropdownColor: Colors.grey[800],
                            ),
                    const SizedBox(height: 16),
                    if (widget.constraint.type ==
                        TimeConstraintType.classAvailability)
                      _classes.isEmpty
                          ? const CircularProgressIndicator()
                          : DropdownButton<String>(
                              value: _selectedId,
                              hint: const Text("Select Class",
                                  style: TextStyle(color: Colors.white)),
                              items: _classes
                                  .map<DropdownMenuItem<String>>((classItem) {
                                return DropdownMenuItem<String>(
                                  value: classItem.id,
                                  child: Text(classItem.name,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedId = value;
                                });
                              },
                              style: const TextStyle(color: Colors.white),
                              dropdownColor: Colors.grey[800],
                            ),
                    const SizedBox(height: 16),
                    if (widget.constraint.type ==
                        TimeConstraintType.roomAvailability)
                      _rooms.isEmpty
                          ? const CircularProgressIndicator()
                          : DropdownButton<String>(
                              value: _selectedId,
                              hint: const Text("Select Room",
                                  style: TextStyle(color: Colors.white)),
                              items:
                                  _rooms.map<DropdownMenuItem<String>>((room) {
                                return DropdownMenuItem<String>(
                                  value: room.id,
                                  child: Text(room.name,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedId = value;
                                });
                              },
                              style: const TextStyle(color: Colors.white),
                              dropdownColor: Colors.grey[800],
                            ),
                    const SizedBox(height: 16),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Active:",
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
                      onPressed: _editConstraint,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 129, 77, 139)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: const Text('Save Changes'),
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

  void _editConstraint() async {
    final updatedConstraint = TimeConstraint(
      id: widget.constraint.id,
      type: widget.constraint.type,
      startTime: _selectedStartTime,
      endTime: _selectedEndTime,
      availableDays: _selectedDays,
      teacherId:
          widget.constraint.type == TimeConstraintType.teacherAvailability
              ? _selectedId
              : null,
      classId: widget.constraint.type == TimeConstraintType.classAvailability
          ? _selectedId
          : null,
      roomId: widget.constraint.type == TimeConstraintType.roomAvailability
          ? _selectedId
          : null,
      isActive: _isActive, // Include active state in the updated constraint
    );
    if (widget.constraint.equals(updatedConstraint)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No changes were made to the constraint'),
      ));
    } else {
      if (_selectedStartTime == null || _selectedEndTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please choose start and end times.')),
        );
        return;
      }

      if (TimeService.timeToMinutes(_selectedStartTime!) >=
          TimeService.timeToMinutes(_selectedEndTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Start time must be less than end time.')),
        );
        return;
      }

      if (_selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one day.')),
        );
        return;
      }
      // Show confirmation dialog
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800], // Set background color to gray
            title: const Text(
              "Confirm Constraint Addition",
              style: TextStyle(color: Colors.white), // White title text
            ),
            content: const Text(
              "Are you sure you want to confirm this changes?",
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
                child: const Text("Confirm",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );

      // If user cancels, do nothing
      if (confirm != true) {
        return;
      }

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final result = await _constraintService.updateConstraint(
          widget.constraint.id!, updatedConstraint);

      // Close loading indicator
      Navigator.pop(context);

      // Show success or error message
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Constraint edited successfully!'),
            duration: Duration(seconds: 2),
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context); // Close the page after success
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    }
  }
}
