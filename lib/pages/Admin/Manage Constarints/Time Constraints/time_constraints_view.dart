import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Time%20Constraints/add_time_constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Time%20Constraints/edit_time_constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Time%20Constraints/time_constaint.details.dart';
import 'package:smarn/services/constraint_service.dart';

class TimeConstraintsView extends StatefulWidget {
  const TimeConstraintsView({super.key});

  @override
  _TimeConstraintsViewState createState() => _TimeConstraintsViewState();
}

class _TimeConstraintsViewState extends State<TimeConstraintsView> {
  final ConstraintService _constraintService = ConstraintService();
  List<TimeConstraint> _timeConstraints = [];

  @override
  void initState() {
    super.initState();
    _fetchTimeConstraints();
  }

  Future<void> _fetchTimeConstraints() async {
    try {
      List<Constraint> constraints = await _constraintService.getAllConstraints();
      List<TimeConstraint> timeConstraints = constraints
          .where((constraint) =>
              constraint.category == ConstraintCategory.timeConstraint)
          .cast<TimeConstraint>()
          .toList();

      if (mounted) {
        setState(() {
          _timeConstraints = timeConstraints;
        });
      }
    } catch (e) {
      print('Error fetching constraints: $e');
    }
  }

  void _navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTimeConstraintView()),
    ).then((_) => _fetchTimeConstraints());
  }

  void _navigateToEdit(TimeConstraint constraint) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTimeConstraintView(constraint: constraint),
      ),
    ).then((_) => _fetchTimeConstraints());
  }

  void _navigateToDetails(TimeConstraint constraint) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeConstraintDetails(constraint: constraint),
      ),
    );
  }

  Future<void> _confirmDelete(TimeConstraint constraint) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this constraint?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _deleteConstraint(constraint.id!);
    }
  }

  Future<void> _deleteConstraint(String constraintId) async {
    final response = await _constraintService.deleteConstraint(constraintId);
    if (response['success']) {
      _fetchTimeConstraints(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Constraint deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Constraints"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _timeConstraints.length,
                  itemBuilder: (context, index) {
                    return _buildConstraintCard(
                      constraint: _timeConstraints[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildConstraintCard({required TimeConstraint constraint}) {
    return InkWell(
      onTap: () {
        _navigateToEdit(constraint);
      },
      child: Card(
        color: const Color.fromARGB(255, 34, 34, 34),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Time Constraint',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ID: ${constraint.id ?? "Unknown"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Type: ${constraint.type.toString().split('.').last}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      _navigateToEdit(constraint);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Color.fromARGB(255, 255, 79, 79)),
                    onPressed: () {
                      _confirmDelete(constraint); // Show confirmation dialog
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: () {
                      _navigateToDetails(constraint);
                    },
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
