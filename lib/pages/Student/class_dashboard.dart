/*

import 'package:flutter/material.dart';
import 'package:smarn/pages/Student/view_timetable.dart';
import 'package:smarn/pages/Teacher/Manage%20qualified%20subjects/manage_qualified_subjects_form.dart';
import 'package:smarn/pages/Teacher/Manage%20Info/manage_personnel_information_form.dart';


class ClassDashboard extends StatelessWidget {
  const ClassDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Class Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: const Color(0xFFF2F2F2),
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: [
              const Text(
                "Welcome to the Class Dashboard",
                style: TextStyle(fontSize: 20, color: Color(0xFF023E8A)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Button for Manage Qualified Subjects
          /*    ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                             ManageQualifiedSubjectsForm()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Manage Qualified Subjects"),
              ),*/
              const SizedBox(height: 20),

              // Button for Manage Personal Information
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ManagePersonnelInformationForm()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Manage Personal Information"),
              ),
              const SizedBox(height: 20),

              // List options for View Complaints and Print Timetable
              const Text(
                "Other Options",
                style: TextStyle(fontSize: 18, color: Color(0xFF023E8A)),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("View Complaints"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ViewTimetable()),
                  );
                },
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                title: const Text("Print Timetable"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const  ViewTimetable()),
                  );
                },
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/