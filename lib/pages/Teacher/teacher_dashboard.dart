import 'package:flutter/material.dart';
import 'package:smarn/pages/Teacher/Manage%20qualified%20subjects/manage_qualified_subjects_form.dart';
import 'package:smarn/pages/Teacher/Manage%20Info/manage_personnel_information_form.dart';
import 'package:smarn/pages/Teacher/Request/view_requests.dart';
import 'package:smarn/pages/Teacher/timetable/view_complaints_or_print_timetable.dart';
import 'package:smarn/pages/Teacher/Request/request_form.dart';
import 'package:smarn/pages/Teacher/Teacher_menu.dart'; // Import the RequestForm
import 'package:smarn/services/auth_service.dart'; // Import the AuthService for logout functionality

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        backgroundColor: Colors.blue,
      ),
      drawer: TeacherDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Main content area now contains the Timetable, Qualified Subjects, and Requests buttons
            Expanded(
              child: Column(
                children: [
                  // Row to place the three cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Timetable Card
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ViewComplaintsOrPrintTimetable(),
                            ),
                          );
                        },
                        child: _buildCard(
                          context,
                          Icons.schedule,
                          'Timetable',
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16), // Space between the cards
                      // Qualified Subjects Card
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ManageQualifiedSubjectsForm(),
                            ),
                          );
                        },
                        child: _buildCard(
                          context,
                          Icons.subject,
                          'Subjects',
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16), // Space between the cards
                      // Requests Card
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewRequests(teacherId: '',), // Navigate to RequestForm
                            ),
                          );
                        },
                        child: _buildCard(
                          context,
                          Icons.request_page,
                          'Requests',
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable widget for the cards (Timetable, Qualified Subjects, Requests)
  Widget _buildCard(
      BuildContext context, IconData icon, String title, Color color) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(12), // Border radius
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the contents
        children: <Widget>[
          Icon(
            icon,
            size: 50,
            color: color,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Logout button widget
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.logout,
            color: Colors.redAccent, size: 20), // Logout icon
        title: const Text(
          'Logout',
          style: TextStyle(
              color: Colors.redAccent, fontSize: 12), // Logout text style
        ),
        tileColor: Colors.transparent,
        onTap: () async {
          // Call the sign-out method from AuthService
          await AuthService().signOut();
          // Navigate to the home page
          Navigator.pushReplacementNamed(context, '/'); // Redirect to HomePage
        },
        hoverColor: Colors.red.withOpacity(0.2), // Hover color effect
      ),
    );
  }
}
