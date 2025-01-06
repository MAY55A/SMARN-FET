import 'package:flutter/material.dart';

class ManageTimetable extends StatefulWidget {
  const ManageTimetable({super.key});

  @override
  _ManageTimetableState createState() => _ManageTimetableState();
}

class _ManageTimetableState extends State<ManageTimetable> {
  final List<Map<String, dynamic>> timetable = [
    {
      'day': 'Monday',
      'time': '08:00 - 09:00',
      'activity': 'SOA',
      'teacher': 'Nour Mansour',
      'room': 'LR001',
      'class': 'DSI3.1',
      'type': 'Lecture'
    },
    {
      'day': 'Monday',
      'time': '08:00 - 09:00',
      'activity': 'Data Security',
      'teacher': 'Mariem',
      'room': 'LR001',
      'class': 'DSI3.1',
      'type': 'Lecture'
    },
    {
      'day': 'Monday',
      'time': '09:00 - 10:00',
      'activity': 'ML',
      'teacher': 'Manel',
      'room': 'RML1',
      'class': 'DSI3.1',
      'type': 'Lab'
    },
    {
      'day': 'Monday',
      'time': '10:00 - 12:00',
      'activity': 'Advanced Programming',
      'teacher': 'Manel',
      'room': 'LR005',
      'class': 'RSI3.1',
      'type': 'Lecture'
    },
    {
      'day': 'Tuesday',
      'time': '10:00 - 12:00',
      'activity': 'ENG110',
      'teacher': 'Sarra Ben Ammar',
      'room': 'Labo1',
      'class': 'RSI3.1',
      'type': 'Tutorial'
    },
    {
      'day': 'Tuesday',
      'time': '14:00 - 15:00',
      'activity': 'Data Visualization',
      'teacher': 'Sarra Ben Ammar',
      'room': 'LR002',
      'class': 'DSI3.2',
      'type': 'Lecture'
    },
    {
      'day': 'Wednesday',
      'time': '08:00 - 09:00',
      'activity': 'SOA',
      'teacher': 'Nour Mansour',
      'room': 'LR002',
      'class': 'DSI3.2',
      'type': 'Lecture'
    },
    {
      'day': 'Wednesday',
      'time': '11:00 - 12:00',
      'activity': 'Data Security',
      'teacher': 'Mariem',
      'room': 'LR003',
      'class': 'RSI3.1',
      'type': 'Lab'
    },
    {
      'day': 'Thursday',
      'time': '09:00 - 11:00',
      'activity': 'ML',
      'teacher': 'Manel',
      'room': 'RML3',
      'class': 'DSI3.2',
      'type': 'Lab'
    },
    {
      'day': 'Thursday',
      'time': '09:00 - 11:00',
      'activity': 'ENG110',
      'teacher': 'Sarra Ben Ammar',
      'room': 'RML3',
      'class': 'DSI3.2',
      'type': 'Lab'
    },
    {
      'day': 'Thursday',
      'time': '09:00 - 11:00',
      'activity': 'DSI Workshop',
      'teacher': 'Lamya Selmi',
      'room': 'RML3',
      'class': 'DSI3.2',
      'type': 'Lab'
    },
    {
      'day': 'Thursday',
      'time': '13:00 - 14:00',
      'activity': 'AI Basics',
      'teacher': 'Lamya Selmi',
      'room': 'RML4',
      'class': 'DSI3.1',
      'type': 'Lecture'
    },
    {
      'day': 'Monday',
      'time': '13:00 - 14:00',
      'activity': 'AI Basics',
      'teacher': 'Lamya Selmi',
      'room': 'RML4',
      'class': 'DSI3.1',
      'type': 'Lecture'
    },
    {
      'day': 'Friday',
      'time': '13:00 - 14:00',
      'activity': 'AI Basics',
      'teacher': 'Lamya Selmi',
      'room': 'RML4',
      'class': 'DSI3.1',
      'type': 'Lecture'
    },
    {
      'day': 'Friday',
      'time': '10:00 - 12:00',
      'activity': 'Data Science',
      'teacher': 'Nour Mansour',
      'room': 'LR004',
      'class': 'DSI3.2',
      'type': 'Lecture'
    },
    {
      'day': 'Friday',
      'time': '10:00 - 12:00',
      'activity': 'Data Security',
      'teacher': 'Mariem',
      'room': 'LR004',
      'class': 'RSI3.1',
      'type': 'Lecture'
    },
    {
      'day': 'Friday',
      'time': '14:00 - 15:00',
      'activity': 'ML',
      'teacher': 'Manel',
      'room': 'LR005',
      'class': 'DSI3.2',
      'type': 'Tutorial'
    },
    {
      'day': 'Friday',
      'time': '14:00 - 15:00',
      'activity': 'Software Engineering',
      'teacher': 'Nour Mansour',
      'room': 'LR005',
      'class': 'DSI3.2',
      'type': 'Tutorial'
    },
  ];

  final List<String> teachers = [
    'Nour Mansour',
    'Manel',
    'Sarra Ben Ammar',
    'Mariem',
    'Lamya Selmi'
  ];

  final List<String> classes = ['DSI3.1', 'RSI3.1', 'DSI3.2'];

  String? selectedTeacher;
  String? selectedClass;

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
                    child: DropdownButton<String>(
                      value: selectedTeacher,
                      hint: const Text("Select Teacher",
                          style: TextStyle(color: Colors.white)),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedTeacher = value;
                          selectedClass = null;
                        });
                      },
                      items: teachers.map((teacher) {
                        return DropdownMenuItem<String>(
                          value: teacher,
                          child: Text(teacher,
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      dropdownColor: Colors.black45,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedClass,
                      hint: const Text("Select Class",
                          style: TextStyle(color: Colors.white)),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedClass = value;
                          selectedTeacher = null;
                        });
                      },
                      items: classes.map((className) {
                        return DropdownMenuItem<String>(
                          value: className,
                          child: Text(className,
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      dropdownColor: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            if (selectedTeacher != null)
              Expanded(
                child: buildTableForTeacher(),
              ),
            if (selectedClass != null)
              Expanded(
                child: buildTableForClass(),
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
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> generateDefaultActivities(String day) {
    return [
      {
        'day': day,
        'time': '08:00 - 09:00',
        'activity': 'General Discussion',
        'teacher': 'TBD',
        'room': 'Room TBD',
        'class': selectedClass ?? 'N/A',
        'type': 'General'
      },
      {
        'day': day,
        'time': '09:00 - 10:00',
        'activity': 'Study Session',
        'teacher': 'TBD',
        'room': 'Room TBD',
        'class': selectedClass ?? 'N/A',
        'type': 'General'
      },
    ];
  }

  Widget buildTableForTeacher() {
    final List<String> weekDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];

    List<Map<String, dynamic>> teacherActivities = timetable.where((entry) {
      return entry['teacher'] == selectedTeacher;
    }).toList();

    List<Map<String, dynamic>> completeSchedule = weekDays.map((day) {
      var activitiesForDay =
          teacherActivities.where((entry) => entry['day'] == day).toList();
      if (activitiesForDay.isEmpty) {
        return {
          'day': day,
          'time': 'N/A',
          'activity': 'No Activity',
          'room': 'N/A',
          'class': 'N/A',
        };
      }
      return activitiesForDay[0];
    }).toList();

    return Card(
      margin: const EdgeInsets.all(10.0),
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 50,
            dataRowHeight: 60,
            columns: const [
              DataColumn(
                label: Text(
                  'Day',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Time',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Activity',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Room',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Class',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: completeSchedule.map((activity) {
              return DataRow(
                cells: [
                  DataCell(Text(activity['day'],
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(activity['time'],
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(activity['activity'],
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(activity['room'],
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(activity['class'],
                      style: const TextStyle(color: Colors.white))),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildTableForClass() {
    final List<String> weekDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];

    List<Map<String, dynamic>> classActivities = timetable.where((entry) {
      return entry['class'] == selectedClass;
    }).toList();

    List<Map<String, dynamic>> completeSchedule = weekDays.expand((day) {
      var activitiesForDay =
          classActivities.where((entry) => entry['day'] == day).toList();
      if (activitiesForDay.isEmpty) {
        return generateDefaultActivities(day);
      }
      return activitiesForDay;
    }).toList();

    return Card(
      margin: const EdgeInsets.all(10.0),
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 50,
            dataRowHeight: 60,
            columns: const [
              DataColumn(
                label: Text(
                  'Day',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Time',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Activity',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Teacher',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Room',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: completeSchedule.map((activity) {
              return DataRow(
                cells: [
                  DataCell(Text(activity['day'],
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(activity['time'],
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(activity['activity'],
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(activity['teacher'],
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(activity['room'],
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
