import 'package:flutter/material.dart';
import 'package:smarn/models/activity.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/work_day.dart';
import 'package:smarn/services/schedule_service.dart';
import 'package:smarn/services/teacher_service.dart';

class ManageTimetableTeacher extends StatefulWidget {
  @override
  _ManageTimetableTeacherState createState() => _ManageTimetableTeacherState();
}

class _ManageTimetableTeacherState extends State<ManageTimetableTeacher> {
  List<Activity>? activities;
  bool _isLoading = false;
  String searchQuery = '';
  final List<WorkDay> daysOfWeek = WorkDay.values.toList();

  @override
  void initState() {
    super.initState();
    _fetchSchedule();
  }

  Future<void> _fetchSchedule() async {
    setState(() {
      _isLoading = true;
    });
    var user = await TeacherService().fetchTeacherData();
    if (user != null) {
      var timetable = await ScheduleService().getLatestScheduleFor(user.id!);
      if (timetable != null) {
        setState(() {
          activities = timetable.activities;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Activity>> groupedByDay = {};
    if (activities != null) {
      List<Activity> filteredTimetable = activities!.where((entry) {
        return entry.studentsClass
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            entry.subject.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      for (var day in daysOfWeek) {
        groupedByDay[day.name] =
            filteredTimetable.where((entry) => entry.day == day).toList();
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Timetable'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : activities == null
                ? const Center(
                    child: Text(
                      'No schedule found',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Search Class/Subject',
                            labelStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.grey.shade800,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: daysOfWeek
                                .where((day) =>
                                    (groupedByDay[day.name] ?? []).isNotEmpty)
                                .map((day) {
                              final activities = groupedByDay[day.name] ?? [];
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                color: Colors.grey.shade900,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          day.name,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      DataTable(
                                        headingRowHeight: 50,
                                        dataRowHeight: 60,
                                        columns: const [
                                          DataColumn(
                                            label: Text(
                                              'Time',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Subject',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Class',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Room',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: activities.map((timingEntry) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(
                                                "${timingEntry.startTime} - ${timingEntry.endTime}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              )),
                                              DataCell(
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        _getColorForActivity(
                                                            timingEntry.tag),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(
                                                    timingEntry.subject,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(Text(
                                                timingEntry.studentsClass,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              )),
                                              DataCell(Text(
                                                timingEntry.room!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              )),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Color _getColorForActivity(ActivityTag tag) {
    switch (tag) {
      case ActivityTag.lecture:
        return Colors.blue.shade300;
      case ActivityTag.seminar:
        return Colors.orange.shade300;
      case ActivityTag.lab:
        return Colors.green.shade300;
      case ActivityTag.workshop:
        return Colors.purple.shade300;
      case ActivityTag.exam:
        return Colors.red.shade300;
      default:
        return Colors.grey.shade700;
    }
  }
}
