import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Scheduling%20Rules%20Constraints/add_scheduling_constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Scheduling%20Rules%20Constraints/edit_scheduling_constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Scheduling%20Rules%20Constraints/scheduling_details.dart';
import 'package:smarn/services/constraint_service.dart';

class SchedulingRulesView extends StatefulWidget {
  const SchedulingRulesView({super.key});

  @override
  _SchedulingRulesViewState createState() => _SchedulingRulesViewState();
}

class _SchedulingRulesViewState extends State<SchedulingRulesView> {
  final ConstraintService _constraintService = ConstraintService();
  late Future<List<SchedulingRule>> _schedulingRules;

  @override
  void initState() {
    super.initState();
    _fetchSchedulingRules();
  }

  void _fetchSchedulingRules() {
    setState(() {
      _schedulingRules = _constraintService.getAllConstraints().then((constraints) {
        return constraints
            .whereType<SchedulingRule>() // Ensure filtering is based on type
            .toList();
      });
    });
  }

  void _navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSchedulingRuleForm(),
      ),
    ).then((_) => _fetchSchedulingRules()); // Refresh after adding
  }

  void _navigateToEdit(SchedulingRule rule) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSchedulingRuleForm(schedulingRule: rule),
      ),
    ).then((_) => _fetchSchedulingRules()); // Refresh after editing
  }

  void _deleteSchedulingRule(String ruleId) async {
    try {
      final result = await _constraintService.deleteConstraint(ruleId);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scheduling Rule deleted successfully.')),
        );
        _fetchSchedulingRules(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete Scheduling Rule.')),
        );
      }
    } catch (e) {
      print('Error deleting scheduling rule: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while deleting.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Scheduling Rules"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: FutureBuilder<List<SchedulingRule>>(
        future: _schedulingRules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No scheduling rules available.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          final schedulingRules = snapshot.data!;
          return Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: schedulingRules.length,
                itemBuilder: (context, index) {
                  final rule = schedulingRules[index];
                  return _buildConstraintCard(
                    title: 'Scheduling Rule ${index + 1}',
                    icon: Icons.calendar_today,
                    onTap: () {
                      _navigateToEdit(rule);
                    },
                    onDelete: () {
                      if (rule.id != null) {
                        _deleteSchedulingRule(rule.id!);
                      }
                    },
                    onDetailsTap: () {
                      // Navigate to scheduling rule details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchedulingRuleDetails(rule: rule),
                        ),
                      );
                    },
                    rule: rule, // Pass the SchedulingRule to the card
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildConstraintCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required VoidCallback onDelete,
    required VoidCallback onDetailsTap,
    required SchedulingRule rule, // Pass the SchedulingRule to this method
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title of the rule
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Display the ID and Type of the rule
                    Text(
                      'ID: ${rule.id ?? "Unknown"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Type: ${rule.type.toString().split('.').last}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: onTap,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: onDelete,
                  ),
                  // Arrow icon to navigate to details
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: onDetailsTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
