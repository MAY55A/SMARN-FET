import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Scheduling%20Rules%20Constraints/add_scheduling_constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Scheduling%20Rules%20Constraints/edit_scheduling_constraint.dart';
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
    _schedulingRules = _constraintService.getAllConstraints().then((constraints) {
      // Filter to only get scheduling rules
      return constraints.where((c) => c is SchedulingRule).toList() as List<SchedulingRule>;
    });
  }

  void _AddSchedulingRule(SchedulingRule rule) {
    // Navigate to the add scheduling rule form
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSchedulingRuleForm(),
      ),
    );
  }

  void _EditSchedulingRule(SchedulingRule rule) {
    // Navigate to the edit form, passing the scheduling rule
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSchedulingRuleForm(schedulingRule: rule),
      ),
    );
  }

  void _deleteSchedulingRule(String ruleId) async {
    final result = await _constraintService.deleteConstraint(ruleId);
    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Scheduling Rule deleted successfully')));
      setState(() {
        _schedulingRules = _constraintService.getAllConstraints().then((constraints) {
          return constraints.where((c) => c is SchedulingRule).toList() as List<SchedulingRule>;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete Scheduling Rule')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No scheduling rules available.'));
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
                      // Navigate to edit scheduling rule
                      _EditSchedulingRule(rule);
                    },
                    onDelete: () => _deleteSchedulingRule(rule.id),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add scheduling rule form
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSchedulingRuleForm()),
          );
        },
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: onTap, // Edit functionality
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: onDelete, // Delete functionality
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
