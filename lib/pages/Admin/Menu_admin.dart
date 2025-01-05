import 'package:flutter/material.dart';
import 'package:smarn/pages/Admin/Account%20Settings/account_setting.dart';
import 'package:smarn/pages/Admin/Account%20Settings/account_setting.dart';
import 'package:smarn/pages/Admin/Manage%20Activities/manage_activities_form.dart';
import 'package:smarn/pages/Admin/Manage%20Classes/manage_classes.dart';
import 'package:smarn/pages/Admin/Manage%20Subjects/manage_subjects_form.dart';
import 'package:smarn/pages/Admin/Manage%20Tables/manage_timetable.dart';
import 'package:smarn/pages/Admin/Manage%20Teachers/manage_teachers_form.dart';
import 'package:smarn/pages/Admin/Manage%20Teachers/manage_teachers_form.dart';
import 'package:smarn/pages/Admin/Manage%20Space/space_constraints_form.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/constarints_selection_page.dart';
import 'package:smarn/pages/Admin/Manage%20requests/manage_requests_form.dart';
import 'package:smarn/pages/Admin/admin_dashboard.dart';
import 'package:smarn/pages/home.dart';
import 'package:smarn/services/auth_service.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({super.key});

  @override
  _AdminMenuState createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  String? userName;
  String? userEmail;
  String? userImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final user = AuthService().getCurrentUser();

    if (user != null) {
      setState(() {
        userName = user.displayName ?? 'Admin';
        userEmail = user.email ?? 'No Email';
        userImageUrl = user.photoURL ??
            'assets/teachers/pfp.jpg'; // Placeholder image if no photo
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.formColor, // Blue background
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName ?? 'Loading...'),
              accountEmail: Text(userEmail ?? 'Loading...'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(userImageUrl!),
              ),
              decoration: BoxDecoration(
                color: AppColors.appBarColor,
              ),
            ),
            // Home Menu Item
            _buildMenuItem(context, Icons.home, 'Home', const HomePage()),

            // Other Menu Items
            _buildMenuItem(context, Icons.person_outline, 'Manage Teachers',
                const ManageTeachersForm()),
            _buildMenuItem(context, Icons.schedule, 'Manage Tables',
                 ManageTimetable()),
            _buildMenuItem(context, Icons.report_problem_outlined,
                'Manage Requests', const ManageComplaintsForm()),
                _buildMenuItem(
  context, Icons.account_circle, 'Account Settings', const AccountSettingsPage()),
                

                

            // Spacer for alignment
            const Spacer(),

            // Logout Menu Item
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title:
                  const Text("Logout", style: TextStyle(color: Colors.white)),
              onTap: () async {
                await AuthService().signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => page)); // Navigate to the specified page
      },
    );
  }
}
