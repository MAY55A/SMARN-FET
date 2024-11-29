import 'package:flutter/material.dart';

class ManageTimetableTeacher extends StatelessWidget {
  final List<Map<String, dynamic>> timetable = [
    {
      'day': 'Monday',
      'time': '08:00 - 09:00',
      'activity': 'Math',
      'class': 'Class A',
      'room': 'Room 101'
    },
    {
      'day': 'Monday',
      'time': '09:00 - 10:00',
      'activity': 'Math',
      'class': 'Class B',
      'room': 'Room 102'
    },
    {
      'day': 'Tuesday',
      'time': '08:00 - 09:00',
      'activity': 'Math',
      'class': 'Class C',
      'room': 'Room 103'
    },
    {
      'day': 'Tuesday',
      'time': '09:00 - 10:00',
      'activity': 'Math',
      'class': 'Class D',
      'room': 'Room 104'
    },
    {
      'day': 'Wednesday',
      'time': '08:00 - 11:00',
      'activity': 'Math',
      'class': 'Class E',
      'room': 'Room 105'
    },
    {
      'day': 'Wednesday',
      'time': '12:00 - 01:00',
      'activity': 'Math',
      'class': 'Class F',
      'room': 'Room 106'
    },
    {
      'day': 'Thursday',
      'time': '08:00 - 09:00',
      'activity': 'Math',
      'class': 'Class G',
      'room': 'Room 107'
    },
    {
      'day': 'Thursday',
      'time': '11:00 - 12:00',
      'activity': 'Math',
      'class': 'Class H',
      'room': 'Room 108'
    },
    {
      'day': 'Friday',
      'time': '02:00 - 03:00',
      'activity': 'Math',
      'class': 'Class I',
      'room': 'Room 109'
    },
    {
      'day': 'Friday',
      'time': '09:00 - 10:00',
      'activity': 'Math',
      'class': 'Class J',
      'room': 'Room 110'
    },
  ];

  final String teacherName = "John Doe"; // Nom de l'enseignant
  final String creationDate =
      "22-Nov-2024"; // Date de création de l'emploi du temps

  ManageTimetableTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    // Organisation des données pour affichage
    Map<String, Map<String, String>> gridData = {};

    for (var entry in timetable) {
      gridData.putIfAbsent(entry['day'], () => {});
      gridData[entry['day']]![entry['time']] =
          '${entry['activity']} : ${entry['room']}\n${entry['class']}';
    }

    List<String> allDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];
    List<String> allTimes = [
      '08:00 - 09:00',
      '09:00 - 10:00',
      '10:00 - 11:00',
      '11:00 - 12:00',
      '01:00 - 02:00',
      '02:00 - 03:00',
    ];

    // Compléter les cases vides avec "No Class"
    for (var time in allTimes) {
      for (var day in allDays) {
        gridData.putIfAbsent(day, () => {});
        gridData[day]!.putIfAbsent(time, () => '');
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manage Timetable (Teacher)'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
        elevation: 8.0,
      ),
      body: Column(
        children: [
          // Added a row below AppBar for teacher name and creation date
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Teacher: $teacherName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Created on: $creationDate',
                  style: const TextStyle(
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
                  rows: allTimes.map((time) {
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
