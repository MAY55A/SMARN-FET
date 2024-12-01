import 'package:flutter/material.dart';
import 'package:smarn/pages/Admin/Manage%20Activities/manage_activities_form.dart'; // Import the Manage Activities form
import 'package:smarn/pages/Admin/Manage%20Classes/manage_classes.dart';
import 'package:smarn/pages/Admin/Manage%20Subjects/manage_subjects_form.dart';
import 'package:smarn/pages/Admin/Manage%20Teachers/manage_teachers_form.dart';
import 'package:smarn/pages/Admin/Manage%20Space/space_constraints_form.dart';
import 'package:smarn/pages/Admin/Manage%20Time%20Constarints/time_constraints_form.dart';
import 'package:smarn/pages/Admin/Menu_admin.dart';
import 'package:smarn/pages/widgets/AppBar.dart';
import 'package:smarn/pages/widgets/dashboard_card.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Dark background
      appBar: Appbar(),
      drawer: const AdminMenu(), // Adding the Admin Menu drawer
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16, // Adjusted spacing for better fit
          mainAxisSpacing: 16,
          children: [
            buildAnimatedDashboardCard(context, 'Manage Classes',
                Icons.group, const ManageClasses()),
            buildAnimatedDashboardCard(context, 'Manage Subjects',
                Icons.book_outlined, const ManageSubjectsForm()),
            buildAnimatedDashboardCard(context, 'Time Constraints',
                Icons.timer_outlined, const TimeConstraintsForm()),
            buildAnimatedDashboardCard(context, 'Manage Space',
                Icons.location_on_outlined, const SpaceConstraintsForm()),
            buildAnimatedDashboardCard(
                context,
                'Manage Activities',
                Icons.assignment,
                const ManageActivitiesForm()), // New dashboard card
          ],
        ),
      ),
    );
  }
}
