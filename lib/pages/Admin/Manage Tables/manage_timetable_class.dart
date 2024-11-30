import 'package:flutter/material.dart';

class ManageTimetableClass extends StatelessWidget {
  final List<Map<String, dynamic>> timetable = [
    {
      'day': 'Monday',
      'time': '08:00 - 09:00',
      'activity': 'Math',
      'room': 'Room 101',
      'class': 'Class A'
    },
    {
      'day': 'Monday',
      'time': '01:00 - 03:00',
      'activity': 'Science',
      'room': 'Room 102',
      'class': 'Class B'
    },
    {
      'day': 'Tuesday',
      'time': '08:00 - 10:00',
      'activity': 'English',
      'room': 'Room 103',
      'class': 'Class C'
    },
    {
      'day': 'Tuesday',
      'time': '01:00 - 02:00',
      'activity': 'Science',
      'room': 'Room 102',
      'class': 'Class D'
    },
    {
      'day': 'Tuesday',
      'time': '02:00 - 03:00',
      'activity': 'History',
      'room': 'Room 104',
      'class': 'Class E'
    },
    {
      'day': 'Wednesday',
      'time': '08:00 - 11:00',
      'activity': 'Physics',
      'room': 'Room 105',
      'class': 'Class F'
    },
    {
      'day': 'Wednesday',
      'time': '12:00 - 01:00',
      'activity': 'Chemistry',
      'room': 'Room 106',
      'class': 'Class G'
    },
    {
      'day': 'Thursday',
      'time': '08:00 - 09:00',
      'activity': 'Biology',
      'room': 'Room 107',
      'class': 'Class H'
    },
    {
      'day': 'Thursday',
      'time': '09:00 - 10:00',
      'activity': 'Geography',
      'room': 'Room 108',
      'class': 'Class I'
    },
    {
      'day': 'Thursday',
      'time': '02:00 - 03:00',
      'activity': 'Art',
      'room': 'Room 109',
      'class': 'Class J'
    },
    {
      'day': 'Friday',
      'time': '10:00 - 12:00',
      'activity': 'Art',
      'room': 'Room 109',
      'class': 'Class K'
    },
    {
      'day': 'Friday',
      'time': '02:00 - 03:00',
      'activity': 'Music',
      'room': 'Room 110',
      'class': 'Class L'
    },
  ];

  ManageTimetableClass({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, String>> gridData = {};
    for (var entry in timetable) {
      gridData.putIfAbsent(entry['day'], () => {});
      gridData[entry['day']]![entry['time']] =
          '${entry['activity']} : ${entry['room']} \n${entry['class']}';
    }

    List<String> allDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manage Timetable (Class)'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
        elevation: 8.0,
      ),
      body: Column(
        children: [
          // Added a row below AppBar for class name and creation date
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Class: Class A',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Created on: 22/11/2024',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 129, 77, 139)),
                  dataRowColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 34, 34, 34)),
                  headingTextStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  columnSpacing: 30.0, // Increased column spacing
                  columns: [
                    const DataColumn(
                      label: SizedBox(
                        width: 150,
                        child: Text(
                          'Time',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ...allDays.map(
                      (day) => DataColumn(
                        label: SizedBox(
                          width: 200, // Increased width for the days
                          child: Text(
                            day,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    '08:00 - 09:00',
                    '09:00 - 10:00',
                    '10:00 - 11:00',
                    '11:00 - 12:00',
                    '01:00 - 02:00',
                    '02:00 - 03:00',
                  ].map((time) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              time,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        ...allDays.map((day) {
                          String content = gridData[day]?[time] ?? '';
                          return DataCell(
                            Container(
                              padding: const EdgeInsets.all(
                                  8.0), // Increased padding
                              constraints: const BoxConstraints(
                                minHeight: 100, // Increased minimum height
                                minWidth: 200, // Increased minimum width
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: Text(
                                content,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
