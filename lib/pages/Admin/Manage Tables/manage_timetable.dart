import 'package:flutter/material.dart';
import 'package:smarn/models/activity.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/models/work_day.dart';
import 'package:smarn/pages/Admin/Manage%20Tables/generate_timetable.dart';
import 'package:smarn/services/class_service.dart';
import 'package:smarn/services/schedule_service.dart';
import 'package:smarn/services/teacher_service.dart';

class ManageTimetable extends StatefulWidget {
  const ManageTimetable({super.key});

  @override
  _ManageTimetableState createState() => _ManageTimetableState();
}

class _ManageTimetableState extends State<ManageTimetable> {
  final List<String> weekDays = WorkDay.values.map((day) => day.name).toList();
  List<Activity> activities = [];
  List<Teacher> _teachers = [];
  List<Class> _classes = [];

  Teacher? selectedTeacher;
  Class? selectedClass;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.wait([
      _fetchTeachers(),
      _fetchClasses(),
    ]);
  }

  Future<void> _fetchSchedule(String id) async {
    setState(() {
      _isLoading = true;
    });
    var timetable = await ScheduleService().getLatestScheduleFor(id);
    setState(() {
      timetable != null ? activities = timetable.activities : activities = [];
      _isLoading = false;
    });
  }

  Future<void> _fetchTeachers() async {
    final teachersList = await TeacherService().getAllTeachers();
    setState(() {
      _teachers =
          teachersList.map((item) => item['teacher'] as Teacher).toList();
    });
  }

  Future<void> _fetchClasses() async {
    final classesList = await ClassService().getAllClasses();
    setState(() {
      _classes = classesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Timetable'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<Teacher>(
                      value: selectedTeacher,
                      hint: const Text("Select Teacher",
                          style: TextStyle(color: Colors.white)),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedTeacher = value;
                          selectedClass = null;
                        });
                        _fetchSchedule(selectedTeacher!.id!);
                      },
                      items: _teachers.map((teacher) {
                        return DropdownMenuItem<Teacher>(
                          value: teacher,
                          child: Text(teacher.name,
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      dropdownColor: Colors.black45,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton<Class>(
                      value: selectedClass,
                      hint: const Text("Select Class",
                          style: TextStyle(color: Colors.white)),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedClass = value;
                          selectedTeacher = null;
                        });
                        _fetchSchedule(selectedClass!.id!);
                      },
                      items: _classes.map((studentsClass) {
                        return DropdownMenuItem<Class>(
                          value: studentsClass,
                          child: Text(studentsClass.name,
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      dropdownColor: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            if (selectedTeacher != null || selectedClass != null)
              Expanded(
                child: buildTable(),
              ),
            if (selectedTeacher == null && selectedClass == null)
              const Expanded(
                child: Center(
                  child: Text(
                    'Please select a teacher or class to view the schedule.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm generation'),
                    content: const Text(
                        'Are you sure you want to generate new timetables ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenerationScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 129, 77, 139),
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate new Timetables'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTable() {
    List<Activity> completeSchedule = weekDays.expand((day) {
      var activitiesForDay =
          activities.where((entry) => entry.day!.name == day).toList();
      return activitiesForDay;
    }).toList();

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : activities.isEmpty
            ? const Center(
                child: Text(
                  'No schedule found',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Card(
                margin: const EdgeInsets.all(10.0),
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 50,
                      dataRowHeight: 60,
                      columns: [
                        const DataColumn(
                          label: Text(
                            'Day',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const DataColumn(
                          label: Text(
                            'Time',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const DataColumn(
                          label: Text(
                            'Subject',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        selectedClass == null
                            ? const DataColumn(
                                label: Text(
                                  'Class',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : const DataColumn(
                                label: Text(
                                  'Teacher',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                        const DataColumn(
                          label: Text(
                            'Room',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: completeSchedule.map((activity) {
                        return DataRow(
                          cells: [
                            DataCell(Text(activity.day!.name,
                                style: const TextStyle(color: Colors.white))),
                            DataCell(Text(
                                "${activity.startTime} - ${activity.endTime}",
                                style: const TextStyle(color: Colors.white))),
                            DataCell(Text(activity.subject,
                                style: const TextStyle(color: Colors.white))),
                            selectedClass == null
                                ? DataCell(Text(activity.studentsClass,
                                    style:
                                        const TextStyle(color: Colors.white)))
                                : DataCell(Text(activity.teacher,
                                    style:
                                        const TextStyle(color: Colors.white))),
                            DataCell(Text(activity.room!,
                                style: const TextStyle(color: Colors.white))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
  }
}