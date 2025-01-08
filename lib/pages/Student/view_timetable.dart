import 'package:flutter/material.dart';
import 'package:smarn/models/activity.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/models/work_day.dart';
import 'package:smarn/services/schedule_service.dart';

class ViewTimetable extends StatefulWidget {
  final Class studentsClass;
  ViewTimetable({required this.studentsClass});

  @override
  _ViewTimetableState createState() => _ViewTimetableState();
}

class _ViewTimetableState extends State<ViewTimetable> {
  List<Activity>? activities;
  String searchQuery = '';
  final List<WorkDay> daysOfWeek = WorkDay.values.toList();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSchedule();
  }

  Future<void> _fetchSchedule() async {
    setState(() {
      _isLoading = true;
    });
    var timetable =
        await ScheduleService().getLatestScheduleFor(widget.studentsClass.id!);
    if (timetable != null) {
      setState(() {
        activities = timetable.activities;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Activity>> groupedByDay = {};
    if (activities != null) {
      // Filtrer les horaires en fonction de la recherche
      List<Activity> filteredTimetable = activities!.where((entry) {
        return entry.teacher
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            entry.subject.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      // Regrouper les horaires par jour
      for (var day in daysOfWeek) {
        groupedByDay[day.name] =
            filteredTimetable.where((entry) => entry.day == day).toList();
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Timetable '),
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
                      // Barre de recherche
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Search Teacher/Subject',
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
                            children: daysOfWeek.map((day) {
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
                                      // En-tête du jour
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
                                      // Affichage des activités ou message
                                      activities.isNotEmpty
                                          ? DataTable(
                                              headingRowHeight: 50,
                                              dataRowHeight: 60,
                                              columns: const [
                                                DataColumn(
                                                  label: Text(
                                                    'Time',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Subject',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Teacher',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Room',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              rows:
                                                  activities.map((timingEntry) {
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
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              _getColorForActivity(
                                                                  timingEntry
                                                                      .tag),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Text(
                                                          timingEntry.subject,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(Text(
                                                      timingEntry.teacher,
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
                                            )
                                          : Center(
                                              child: Text(
                                                'No activities scheduled for ${day.name}',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
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

// Assigner une couleur à chaque activité
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
