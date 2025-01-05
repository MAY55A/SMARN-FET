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
    // Filter by teacher or class
    List<Map<String, dynamic>> filteredTimetable = timetable.where((entry) {
      bool matchesTeacher =
          selectedTeacher == null || entry['teacher'] == selectedTeacher;
      bool matchesClass =
          selectedClass == null || entry['class'] == selectedClass;
      return matchesTeacher && matchesClass;
    }).toList();

    // Group timetable by teacher or class
    Map<String, List<Map<String, dynamic>>> groupedByKey = {};
    if (selectedTeacher != null) {
      for (var entry in filteredTimetable) {
        groupedByKey.putIfAbsent(entry['day'], () => []).add(entry);
      }
    } else if (selectedClass != null) {
      for (var entry in filteredTimetable) {
        groupedByKey.putIfAbsent(entry['day'], () => []).add(entry);
      }
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
                          selectedClass = null; // Reset class selection
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
                          selectedTeacher = null; // Reset teacher selection
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
            // Display timetable grouped by teacher or class
            Expanded(
              child: groupedByKey.isNotEmpty
                  ? ListView.builder(
                      itemCount: groupedByKey.keys.length,
                      itemBuilder: (context, index) {
                        String key = groupedByKey.keys.elementAt(index);
                        List<Map<String, dynamic>> entries = groupedByKey[key]!;
                        return Card(
                          color: Colors.grey.shade900,
                          margin: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$key:",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  children: entries.map((entry) {
                                    return ListTile(
                                      title: Text(
                                        entry['activity'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        "Time: ${entry['time']}\nRoom: ${entry['room']}",
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      trailing: Text(
                                        entry['type'],
                                        style: TextStyle(
                                          color: activityColors[entry['type']],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
