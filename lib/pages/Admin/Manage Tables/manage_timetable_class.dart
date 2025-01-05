import 'package:flutter/material.dart';

class ManageTimetableClass extends StatefulWidget {
  @override
  _ManageTimetableClassState createState() => _ManageTimetableClassState();
}

class _ManageTimetableClassState extends State<ManageTimetableClass> {
  final List<Map<String, dynamic>> timetable = [
    {
      'day': 'Monday',
      'time': '08:00 - 09:00',
      'activity': 'SOA',
      'teacher': 'Nour Mansour',
      'room': 'LR001',
      'type': 'Lecture',
      'startTime': '08:00',
      'endTime': '09:00',
    },
    {
      'day': 'Monday',
      'time': '09:00 - 10:00',
      'activity': 'ML',
      'teacher': 'Manel',
      'room': 'RML1',
      'type': 'Lab',
      'startTime': '09:00',
      'endTime': '10:00',
    },
    {
      'day': 'Tuesday',
      'time': '10:00 - 12:00',
      'activity': 'ENG110',
      'teacher': 'Sarra Ben Ammar',
      'room': 'Labo1',
      'type': 'Tutorial',
      'startTime': '10:00',
      'endTime': '12:00',
    },
    {
      'day': 'Wednesday',
      'time': '08:00 - 09:00',
      'activity': 'DSI Lecture',
      'teacher': 'Mariem',
      'room': 'LR002',
      'type': 'Lecture',
      'startTime': '08:00',
      'endTime': '09:00',
    },
    {
      'day': 'Thursday',
      'time': '09:00 - 11:00',
      'activity': 'DSI Workshop',
      'teacher': 'Lamya Selmi',
      'room': 'RML3',
      'type': 'Lab',
      'startTime': '09:00',
      'endTime': '11:00',
    },
    {
      'day': 'Friday',
      'time': '10:00 - 12:00',
      'activity': 'Data Science',
      'teacher': 'Nour Mansour',
      'room': 'LR004',
      'type': 'Lecture',
      'startTime': '10:00',
      'endTime': '12:00',
    },
    {
      'day': 'Monday',
      'time': '10:00 - 12:00',
      'activity': 'Advanced Programming',
      'teacher': 'Manel',
      'room': 'LR005',
      'type': 'Lecture',
      'startTime': '10:00',
      'endTime': '12:00',
    },
  ];

  String searchText = '';

  // Assign colors for different types of activities
  Map<String, Color> activityColors = {
    'Lecture': Colors.blue.shade300,
    'Lab': Colors.orange.shade300,
    'Tutorial': Colors.green.shade300,
  };

  @override
  Widget build(BuildContext context) {
    // Filter timetable based on search query
    List<Map<String, dynamic>> filteredTimetable = timetable.where((entry) {
      return entry['activity']
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          entry['teacher'].toLowerCase().contains(searchText.toLowerCase()) ||
          entry['room'].toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    // Group timetable by day
    Map<String, List<Map<String, dynamic>>> groupedByDay = {};
    for (var entry in filteredTimetable) {
      if (!groupedByDay.containsKey(entry['day'])) {
        groupedByDay[entry['day']] = [];
      }
      groupedByDay[entry['day']]!.add(entry);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manage Timetable (Class)'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search Teacher/Class',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Display each day's timetable
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: groupedByDay.entries.map((entry) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: Colors.grey.shade900,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Day Header
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            // Timetable Table for each day
                            DataTable(
                              headingRowHeight: 50,
                              dataRowHeight: 60,
                              columns: const [
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
                                    label: Text('Teacher',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Room',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: entry.value.map((timingEntry) {
                                return DataRow(
                                  color:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                    return (entry.value.indexOf(timingEntry) %
                                                2 ==
                                            0)
                                        ? Colors.grey.shade800
                                        : Colors.black;
                                  }),
                                  cells: [
                                    DataCell(Text(timingEntry['time'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14))),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color:
                                            activityColors[timingEntry['type']],
                                        child: Text(timingEntry['activity'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ),
                                    ),
                                    DataCell(Text(timingEntry['teacher'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14))),
                                    DataCell(Text(timingEntry['room'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14))),
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
}
