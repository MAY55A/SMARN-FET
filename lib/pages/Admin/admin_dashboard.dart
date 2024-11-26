import 'package:flutter/material.dart';
import 'package:smarn/pages/Admin/Manage%20Activities/manage_activities_form.dart'; // Import the Manage Activities form
import 'package:smarn/pages/Admin/Manage%20Classes/manage_classes.dart';
import 'package:smarn/pages/Admin/Manage%20Subjects/manage_subjects_form.dart';
import 'package:smarn/pages/Admin/Manage%20Tables/manage_timetable.dart';
import 'package:smarn/pages/Admin/Manage%20Teachers/manage_teachers_form.dart';
import 'package:smarn/pages/Admin/Manage%20Space/space_constraints_form.dart';
import 'package:smarn/pages/Admin/Manage%20Time%20Constarints/time_constraints_form.dart';
import 'package:smarn/pages/Admin/Manage%20requests/manage_complaints_form.dart';
import 'package:smarn/pages/Admin/Menu_admin.dart';
import 'package:smarn/pages/widgets/AppBar.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/auth_service.dart'; // Import the AdminMenu

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Dark background
      appBar: Appbar(),
<<<<<<< HEAD
      body: Row(
        children: [
          // Sidebar with adjusted width
          Container(
            width: 150, // Reduced sidebar width
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 56, 56, 56), // Dark sidebar
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.black12)
              ], // Shadow for depth
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      _buildSidebarItem(context, Icons.person_outline,
                          'Manage Teachers', const ManageTeachersForm()),
                      _buildSidebarItem(context, Icons.schedule,
                          'Manage Tables', const ManageTimetable()),
                      _buildSidebarItem(context, Icons.report_problem_outlined,
                          'Manage Requests', const ManageComplaintsForm()),
                      // New sidebar item
                    ],
                  ),
                ),
                _buildLogoutButton(context), // Logout Button at the bottom
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
                  _buildAnimatedDashboardCard(context, 'Manage Classes',
                      Icons.group, const ManageClasses()),
                  _buildAnimatedDashboardCard(context, 'Manage Subjects',
                      Icons.book_outlined, const ManageSubjectsForm()),
                  _buildAnimatedDashboardCard(context, 'Time Constraints',
                      Icons.timer_outlined, const TimeConstraintsForm()),
                  _buildAnimatedDashboardCard(context, 'Manage Space',
                      Icons.location_on_outlined, const SpaceConstraintsForm()),
                  _buildAnimatedDashboardCard(
                      context,
                      'Manage Activities',
                      Icons.assignment,
                      const ManageActivitiesForm()), // New dashboard card
                ],
              ),
            ),
          ),
        ],
=======
      drawer: const AdminMenu(), // Adding the Admin Menu drawer
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16, // Adjusted spacing for better fit
          mainAxisSpacing: 16,
          children: [
            _buildAnimatedDashboardCard(context, 'Manage Classes',
                Icons.group, const ManageClasses()),
            _buildAnimatedDashboardCard(context, 'Manage Subjects',
                Icons.book_outlined, const ManageSubjectsForm()),
            _buildAnimatedDashboardCard(context, 'Time Constraints',
                Icons.timer_outlined, const TimeConstraintsForm()),
            _buildAnimatedDashboardCard(context, 'Manage Space',
                Icons.location_on_outlined, const SpaceConstraintsForm()),
            _buildAnimatedDashboardCard(
                context,
                'Manage Activities',
                Icons.assignment,
                const ManageActivitiesForm()), // New dashboard card
          ],
        ),
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
      ),
    );
  }

<<<<<<< HEAD
  // Sidebar item with hover effect and icon
  Widget _buildSidebarItem(
      BuildContext context, IconData icon, String title, Widget page) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 10), // Reduced vertical margin
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 20), // Reduced icon size
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 12), // Smaller font size
        ),
        tileColor: Colors.transparent,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      page)); // Navigate to the specified page
        },
        hoverColor: Colors.white24,
      ),
    );
  }

=======
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
  // Dashboard card with 3D effect, shadow, and hover animation
  Widget _buildAnimatedDashboardCard(
    BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => page)); // Navigate to the specified page
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), // Slightly adjusted radius
          color: const Color.fromARGB(255, 84, 84, 84),
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
<<<<<<< HEAD
          splashColor: const Color.fromARGB(255, 56, 56, 56),
          // Splash effect
=======
          splashColor: Color.fromARGB(255, 56, 56, 56), // Splash effect
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(12.0), // Adjusted padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
<<<<<<< HEAD
                Icon(icon,
                    size: 36,
                    color: AppColors.appBarColor), // Further reduced icon size
=======
                Icon(icon, size: 36, color: AppColors.appBarColor), // Further reduced icon size
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                const SizedBox(height: 8), // Reduced spacing
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12, // Smaller font size
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(
                        255, 254, 254, 254), // Same as sidebar for uniformity
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
