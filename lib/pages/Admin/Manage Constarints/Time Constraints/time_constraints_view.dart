import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Time%20Constraints/add_time_constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Time%20Constraints/edit_time_constraint.dart';
import 'package:smarn/services/constraint_service.dart';



class TimeConstraintsView extends StatefulWidget {
  const TimeConstraintsView({super.key});

  @override
  _TimeConstraintsViewState createState() => _TimeConstraintsViewState();
}

class _TimeConstraintsViewState extends State<TimeConstraintsView> {
  final ConstraintService _constraintService = ConstraintService();
  List<Constraint> _constraints = [];

  @override
  void initState() {
    super.initState();
    _fetchConstraints();
  }

  Future<void> _fetchConstraints() async {
    List<Constraint> constraints = await _constraintService.getAllConstraints();
    setState(() {
      _constraints = constraints;
    });
  }

  void _navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTimeConstraintView()),
    ).then((_) => _fetchConstraints()); // Refresh data after adding
  }

  void _navigateToEdit(Constraint constraint) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTimeConstraintView(constraint: constraint),
      ),
    ).then((_) => _fetchConstraints()); // Refresh data after editing
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
                  itemCount: _constraints.length,
                  itemBuilder: (context, index) {
                    return _buildConstraintCard(
                      constraint: _constraints[index],
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

  Widget _buildConstraintCard({required Constraint constraint}) {
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
              Icon(Icons.access_time, color: Colors.white, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Time Constraint: ${constraint.id}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  _navigateToEdit(constraint);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  // Implement delete functionality
                },
              ),
              IconButton(
                icon: const Icon(Icons.remove_red_eye, color: Colors.white),
                onPressed: () {
                  // View constraint details
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
