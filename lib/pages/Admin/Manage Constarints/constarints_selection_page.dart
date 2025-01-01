import 'package:flutter/material.dart';

import 'package:smarn/pages/Admin/Manage%20Constarints/Scheduling%20Rules%20Constraints/scheduling_rules_view.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Space%20Constraints/space_constraints_view.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Time%20Constraints/time_constraints_view.dart';

class ConstraintsSelection extends StatefulWidget {
  const ConstraintsSelection({super.key});

  @override
  _ConstraintsSelectionState createState() => _ConstraintsSelectionState();
}

class _ConstraintsSelectionState extends State<ConstraintsSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Constraints"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildConstraintCard(
                title: 'Time Constraints',
                icon: Icons.access_time,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TimeConstraintsView(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildConstraintCard(
                title: 'Space Constraints',
                icon: Icons.location_on,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SpaceConstraintsView(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildConstraintCard(
                title: 'Scheduling Rules',
                icon: Icons.calendar_today,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SchedulingRulesView(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConstraintCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: const Color.fromARGB(255, 34, 34, 34),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}