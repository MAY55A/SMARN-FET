import 'package:flutter/material.dart';
import 'manage_timetable_teacher.dart';
import 'manage_timetable_class.dart';

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
      backgroundColor: const Color.fromARGB(
          255, 0, 0, 0), // Dark background (same as AdminDashboard)
      appBar: AppBar(
        title: const Text('Manage Timetable'),
        backgroundColor: const Color.fromARGB(
            255, 129, 77, 139), // Maintain original app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 129, 77, 139), // Maintain original button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageTimetableTeacher(),
                    ),
                  );
                },
                child: const Text(
                  'Manage Timetable (Teacher)',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 129, 77, 139), // Maintain original button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageTimetableClass(),
                    ),
                  );
                },
                child: const Text(
                  'Manage Timetable (Class)',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
