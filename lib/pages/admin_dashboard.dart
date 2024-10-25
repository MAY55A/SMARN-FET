import 'package:flutter/material.dart';
import 'package:smarn/pages/manage_complaints_form.dart';
import 'package:smarn/pages/manage_students_form.dart';
import 'package:smarn/pages/manage_subjects_form.dart';
import 'package:smarn/pages/manage_teachers_form.dart';
import 'package:smarn/pages/manage_timetables_form.dart';
import 'package:smarn/pages/space_constraints_form.dart';
import 'package:smarn/pages/time_constraints_form.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 9, 17), // Dark background
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139), // AppBar color
        elevation: 4, // Slight elevation for shadow effect
      ),
      body: Row(
        children: [
          // Sidebar with adjusted width
          Container(
            width: 160, // Reduced sidebar width
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 44, 44, 44), // Dark sidebar
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.black12)
              ], // Shadow for depth
            ),
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _buildSidebarItem(context, Icons.person_outline, 'Manage Teachers', const ManageTeachersForm()),
                _buildSidebarItem(context, Icons.schedule, 'Manage Timetables', const ManageTimetablesForm()),
                _buildSidebarItem(context, Icons.report_problem_outlined, 'Manage Complaints', const ManageComplaintsForm()),
              ],
            ),
          ),
          // Main Content with card animations
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16, // Adjusted spacing for better fit
                mainAxisSpacing: 16,
                children: [
                  _buildAnimatedDashboardCard(context, 'Manage Students', Icons.group, const ManageStudentsForm()),
                  _buildAnimatedDashboardCard(context, 'Manage Subjects', Icons.book_outlined, const ManageSubjectsForm()),
                  _buildAnimatedDashboardCard(context, 'Time Constraints', Icons.timer_outlined, const TimeConstraintsForm()),
                  _buildAnimatedDashboardCard(context, 'Space Constraints', Icons.location_on_outlined, const SpaceConstraintsForm()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar item with hover effect and icon
  Widget _buildSidebarItem(BuildContext context, IconData icon, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 20), // Reduced icon size
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 12), // Smaller font size
        ),
        tileColor: Colors.transparent,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page)); // Navigate to the specified page
        },
        hoverColor: Colors.white24,
      ),
    );
  }

  // Dashboard card with 3D effect, shadow, and hover animation
  Widget _buildAnimatedDashboardCard(BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page)); // Navigate to the specified page
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), // Slightly adjusted radius
          color: const Color.fromARGB(255, 232, 232, 232),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 6,
              offset: const Offset(0, 3), // Creates a more subtle shadow
            ),
          ],
        ),
        child: InkWell(
          splashColor: const Color.fromARGB(255, 17, 111, 188).withOpacity(0.3), // Splash effect
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(12.0), // Adjusted padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: Colors.blue), // Further reduced icon size
                const SizedBox(height: 8), // Reduced spacing
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12, // Smaller font size
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF023E8A), // Same as sidebar for uniformity
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
