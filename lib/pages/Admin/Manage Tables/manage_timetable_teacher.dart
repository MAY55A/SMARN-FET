import 'package:flutter/material.dart';

class ManageTimetableTeacher extends StatefulWidget {
  @override
  _ManageTimetableTeacherState createState() => _ManageTimetableTeacherState();
}

class _ManageTimetableTeacherState extends State<ManageTimetableTeacher> {
  final List<Map<String, dynamic>> timetable = [
    // Lundi
    {
      'day': 'Monday',
      'time': '08:00 - 09:00',
      'activity': 'SOA',
      'class': 'DSI3.1',
      'room': 'LR001',
    },
    {
      'day': 'Monday',
      'time': '09:00 - 10:00',
      'activity': 'ML',
      'class': 'DSI3.2',
      'room': 'RML1',
    },
    // Mardi
    {
      'day': 'Tuesday',
      'time': '08:00 - 09:00',
      'activity': 'CS101',
      'class': 'RSI3.1',
      'room': 'LABO1',
    },
    {
      'day': 'Tuesday',
      'time': '10:00 - 12:00',
      'activity': 'ENG110',
      'class': 'MDW2.1',
      'room': 'LR001',
    },
    // Mercredi
    {
      'day': 'Wednesday',
      'time': '10:00 - 11:00',
      'activity': 'DBMS',
      'class': 'DSI3.1',
      'room': 'LR003',
    },
    // Jeudi
    {
      'day': 'Thursday',
      'time': '08:00 - 09:30',
      'activity': 'AI',
      'class': 'DSI3.1',
      'room': 'LR002',
    },
    {
      'day': 'Thursday',
      'time': '11:00 - 12:00',
      'activity': 'Physics',
      'class': 'DSI3.2',
      'room': 'RML1',
    },
    // Vendredi
    {
      'day': 'Friday',
      'time': '09:00 - 10:30',
      'activity': 'Chemistry',
      'class': 'DSI3.1',
      'room': 'LR001',
    },
    // Samedi
    {
      'day': 'Saturday',
      'time': '10:00 - 11:30',
      'activity': 'Ethics',
      'class': 'RSI3.1',
      'room': 'LR004',
    },
  ];

  String searchQuery = '';

  // Liste des jours (dimanche supprimé)
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  Widget build(BuildContext context) {
    // Filtrer les horaires en fonction de la recherche
    List<Map<String, dynamic>> filteredTimetable = timetable.where((entry) {
      return entry['class'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          entry['activity'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    // Regrouper les horaires par jour
    Map<String, List<Map<String, dynamic>>> groupedByDay = {};
    for (var day in daysOfWeek) {
      groupedByDay[day] =
          filteredTimetable.where((entry) => entry['day'] == day).toList();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manage Timetable (Teacher)'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                  labelText: 'Search Class/Activity',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: daysOfWeek.map((day) {
                    final activities = groupedByDay[day] ?? [];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: Colors.grey.shade900,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // En-tête du jour
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                day,
                                style: TextStyle(
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Activity',
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
                                            timingEntry['time'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          )),
                                          DataCell(
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: _getColorForActivity(
                                                    timingEntry['activity']),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                timingEntry['activity'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(
                                            timingEntry['class'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          )),
                                          DataCell(Text(
                                            timingEntry['room'],
                                            style: TextStyle(
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
                                      'No activities scheduled for $day',
                                      style: TextStyle(
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
  Color _getColorForActivity(String activity) {
    switch (activity) {
      case 'SOA':
        return Colors.blue.shade300;
      case 'ML':
        return Colors.orange.shade300;
      case 'CS101':
        return Colors.green.shade300;
      case 'ENG110':
        return Colors.purple.shade300;
      case 'DBMS':
        return Colors.red.shade300;
      case 'AI':
        return Colors.teal.shade300;
      case 'Physics':
        return Colors.pink.shade300;
      case 'Chemistry':
        return Colors.yellow.shade300;
      default:
        return Colors.grey.shade700;
    }
  }
}
