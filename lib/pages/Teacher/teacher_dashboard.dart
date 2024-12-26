import 'package:flutter/material.dart';
import 'package:smarn/pages/Teacher/Activities/view_activities.dart';
import 'package:smarn/pages/Teacher/Manage%20qualified%20subjects/manage_qualified_subjects_form.dart';
import 'package:smarn/pages/Teacher/Request/view_requests.dart';
import 'package:smarn/pages/Teacher/timetable/view_timetable.dart';
import 'package:smarn/pages/Teacher/Teacher_menu.dart';
import 'package:smarn/pages/widgets/dashboard_card.dart';
import 'package:smarn/services/auth_service.dart';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16, // Adjusted spacing for better fit
            mainAxisSpacing: 16,
            children: [
              buildAnimatedDashboardCard(context, 'Timetable', Icons.schedule,
                  const ViewComplaintsOrPrintTimetable(),Colors.blue),
              buildAnimatedDashboardCard(context, 'Subjects',
                  Icons.book_outlined, ManageQualifiedSubjectsForm(),Colors.blue),
              buildAnimatedDashboardCard(context, 'Activities',
                  Icons.assignment, const ViewActivities(),Colors.blue),
              buildAnimatedDashboardCard(context, 'Change Requests',
                  Icons.location_on_outlined, const ViewRequests(),Colors.blue),
            ],
          ),
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
          Navigator.pushNamedAndRemoveUntil(
              context, '/', (route) => false); // Redirect to HomePage
        },
        hoverColor: Colors.red.withOpacity(0.2), // Hover color effect
      ),
    );
  }
}
