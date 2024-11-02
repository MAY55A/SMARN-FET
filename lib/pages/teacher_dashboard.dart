import 'package:flutter/material.dart';
import 'package:smarn/pages/manage_qualified_subjects_form.dart';
import 'package:smarn/pages/manage_personnel_information_form.dart';
import 'package:smarn/pages/view_complaints_or_print_timetable.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: Row(
        children: [
          // Static Sidebar on the left
          Container(
            width: 170, // Sidebar width
            color: Colors.grey[800], // Background color for sidebar
            child: Column(
              children: [
                const SizedBox(height: 20), // Space at the top
                ListTile(
                  leading: const Icon(Icons.subject, color: Colors.white),
                  title: const Text(
                    'Qualified Subjects',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ManageQualifiedSubjectsForm()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text(
                    'Personnel Info',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ManagePersonnelInformationForm()),
                    );
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: Stack(
              children: [
                // Aligning the timetable button to top-left
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Corrected padding line
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ViewComplaintsOrPrintTimetable()),
                        );
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(12), // Fixed border radius
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Fixed alignment
                          children: <Widget>[
                            const Icon(
                              Icons.schedule,
                              size: 50,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Timetable',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
