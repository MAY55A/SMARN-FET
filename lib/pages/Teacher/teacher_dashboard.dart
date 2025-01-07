import 'package:flutter/material.dart';
import 'package:smarn/pages/Teacher/Activities/view_activities.dart';
import 'package:smarn/pages/Teacher/Manage%20qualified%20subjects/manage_qualified_subjects_form.dart';
import 'package:smarn/pages/Teacher/Request/view_requests.dart';
import 'package:smarn/pages/Teacher/timetable/view_timetable.dart';
import 'package:smarn/pages/Teacher/Teacher_menu.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        backgroundColor: Colors.blue,
      ),
      drawer: TeacherDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjusted for better responsiveness
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.5,
                ),
                shrinkWrap: true, // Ensures GridView takes minimal space
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildDashboardCard(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, int index) {
    final items = [
      {'title': 'Timetable', 'icon': Icons.schedule, 'page': ManageTimetableTeacher()},
      {'title': 'Subjects', 'icon': Icons.book_outlined, 'page': ManageQualifiedSubjectsForm()},
      {'title': 'Activities', 'icon': Icons.assignment, 'page': const ViewActivities()},
      {'title': 'Requests', 'icon': Icons.location_on_outlined, 'page': const ViewRequests()},
    ];

    final item = items[index];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item['page'] as Widget),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              item['icon'] as IconData,
              size: 70,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            Text(
              item['title'] as String,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
