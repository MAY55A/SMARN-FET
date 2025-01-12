import 'package:flutter/material.dart';
import 'package:smarn/pages/Admin/Manage%20Activities/manage_activities_form.dart'; // Import the Manage Activities form
import 'package:smarn/pages/Admin/Manage%20Classes/manage_classes.dart';
import 'package:smarn/pages/Admin/Manage%20Subjects/manage_subjects_form.dart';
import 'package:smarn/pages/Admin/Manage%20Space/space_constraints_form.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/constarints_selection_page.dart';
import 'package:smarn/pages/Admin/Menu_admin.dart';
import 'package:smarn/pages/widgets/AppBar.dart';
import 'package:smarn/pages/widgets/canstants.dart';

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Define card dimensions and layout based on screen size
            double cardWidth = constraints.maxWidth > 600 ? 120 : double.infinity; // Smaller width
            double cardHeight = constraints.maxWidth > 600 ? 80 : 60; // Smaller height
            double iconSize = constraints.maxWidth > 700 ? 60 : 60; // Bigger icon size
            double textSize = constraints.maxWidth > 500 ? 15 : 15; // Bigger text size

            return GridView.count(
              crossAxisCount: constraints.maxWidth > 600 ? 3 : 2, // 3 columns on larger screens
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                buildAnimatedDashboardCard(
                  context,
                  'Manage Classes',
                  Icons.group,
                  const ManageClasses(),
                  AppColors.formColor,
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  iconSize: iconSize,
                  textSize: textSize,
                ),
                buildAnimatedDashboardCard(
                  context,
                  'Manage Subjects',
                  Icons.book_outlined,
                  const ManageSubjectsForm(),
                  AppColors.formColor,
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  iconSize: iconSize,
                  textSize: textSize,
                ),
                buildAnimatedDashboardCard(
                  context,
                  'Manage Constraints',
                  Icons.timer_outlined,
                  const ConstraintsSelection(),
                  AppColors.formColor,
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  iconSize: iconSize,
                  textSize: textSize,
                ),
                buildAnimatedDashboardCard(
                  context,
                  'Manage Space',
                  Icons.location_on_outlined,
                  const SpaceConstraintsForm(),
                  AppColors.formColor,
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  iconSize: iconSize,
                  textSize: textSize,
                ),
                buildAnimatedDashboardCard(
                  context,
                  'Manage Activities',
                  Icons.assignment,
                  const ManageActivitiesForm(),
                  AppColors.formColor,
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  iconSize: iconSize,
                  textSize: textSize,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildAnimatedDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget navigateTo,
    Color color, {
    double? cardWidth,
    double? cardHeight,
    double? iconSize,
    double? textSize,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => navigateTo),
        );
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color:AppColors.appBarColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
