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
      'time': '09:00 - 10:00',
      'activity': 'ML',
      'teacher': 'Manel',
      'room': 'RML1',
      'class': 'DSI3.1',
      'type': 'Lab'
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
      'day': 'Wednesday',
      'time': '08:00 - 09:00',
      'activity': 'DSI Lecture',
      'teacher': 'Mariem',
      'room': 'LR002',
      'class': 'DSI3.2',
      'type': 'Lecture'
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
      'day': 'Friday',
      'time': '10:00 - 12:00',
      'activity': 'Data Science',
      'teacher': 'Nour Mansour',
      'room': 'LR004',
      'class': 'DSI3.1',
      'type': 'Lecture'
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
  ];

  String searchText = '';
  String? selectedTeacher;
  String? selectedClass;

  final List<String> teachers = [
    'Nour Mansour',
    'Manel',
    'Sarra Ben Ammar',
    'Mariem',
    'Lamya Selmi'
  ];
  final List<String> classes = ['DSI3.1', 'RSI3.1', 'DSI3.2'];

  final Map<String, Color> activityColors = {
    'Lecture': Colors.blue.shade300,
    'Lab': Colors.orange.shade300,
    'Tutorial': Colors.green.shade300,
  };

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTimetable = timetable.where((entry) {
      bool matchesTeacher =
          selectedTeacher == null || entry['teacher'] == selectedTeacher;
      bool matchesClass =
          selectedClass == null || entry['class'] == selectedClass;
      bool matchesSearch = entry['activity']
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          entry['teacher'].toLowerCase().contains(searchText.toLowerCase()) ||
          entry['room'].toLowerCase().contains(searchText.toLowerCase()) ||
          entry['day'].toLowerCase().contains(searchText.toLowerCase());
      return matchesTeacher && matchesClass && matchesSearch;
    }).toList();

    // Group timetable by teacher
    Map<String, List<Map<String, dynamic>>> groupedByTeacher = {};
    for (var entry in filteredTimetable) {
      groupedByTeacher.putIfAbsent(entry['teacher'], () => []).add(entry);
    }

    // Group timetable by class
    Map<String, List<Map<String, dynamic>>> groupedByClass = {};
    for (var entry in filteredTimetable) {
      groupedByClass.putIfAbsent(entry['class'], () => []).add(entry);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Timetable'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search Teacher/Class/Activity',
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
            // Dropdowns to select teacher or class
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Dropdown to select teacher
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedTeacher,
                      hint: const Text("Select Teacher",
                          style: TextStyle(color: Colors.white)),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedTeacher = value;
                          selectedClass = null; // Reset the class selection
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
                  // Dropdown to select class
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedClass,
                      hint: const Text("Select Class",
                          style: TextStyle(color: Colors.white)),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedClass = value;
                          selectedTeacher = null; // Reset the teacher selection
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
            // Display timetable for selected teacher or class
            Expanded(
              child: filteredTimetable.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowHeight: 50,
                        dataRowHeight: 60,
                        columns: selectedTeacher != null
                            ? const [
                                DataColumn(
                                    label: Text('Day',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Time',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Activity',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Room',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Class',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              ]
                            : const [
                                DataColumn(
                                    label: Text('Day',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Time',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Activity',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Room',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Teacher',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              ],
                        rows: filteredTimetable.map((entry) {
                          return DataRow(
                            cells: selectedTeacher != null
                                ? [
                                    DataCell(Text(entry['day'],
                                        style: const TextStyle(
                                            color: Colors.white))),
                                    DataCell(Text(entry['time'],
                                        style: const TextStyle(
                                            color: Colors.white))),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: activityColors[entry['type']],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(entry['activity'],
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                    DataCell(Text(entry['room'],
                                        style: const TextStyle(
                                            color: Colors.white))),
                                    DataCell(Text(entry['class'],
                                        style: const TextStyle(
                                            color: Colors.white))),
                                  ]
                                : [
                                    DataCell(Text(entry['day'],
                                        style: const TextStyle(
                                            color: Colors.white))),
                                    DataCell(Text(entry['time'],
                                        style: const TextStyle(
                                            color: Colors.white))),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: activityColors[entry['type']],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(entry['activity'],
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                    DataCell(Text(entry['room'],
                                        style: const TextStyle(
                                            color: Colors.white))),
                                    DataCell(Text(entry['teacher'],
                                        style: const TextStyle(
                                            color: Colors.white))),
                                  ],
                          );
                        }).toList(),
                      ),
                    )
                  : const Center(
                      child: Text(
                        "No timetable entries found.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
