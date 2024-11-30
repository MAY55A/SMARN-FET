import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';

class ViewTeacherDetailsForm extends StatelessWidget {
  final Teacher teacher;

  const ViewTeacherDetailsForm({Key? key, required this.teacher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Details"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      backgroundColor: Colors.black,  // Set the background color of the entire screen to black
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${teacher.name}', style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Text('Email: ${teacher.email ?? 'Not Provided'}', style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Text('Phone: ${teacher.phone}', style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Text('Number of Hours: ${teacher.nbHours}', style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Text('Subjects: ${teacher.subjects.isNotEmpty ? teacher.subjects.join(', ') : 'No subjects assigned'}',
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
