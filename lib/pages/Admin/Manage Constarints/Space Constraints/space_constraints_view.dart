import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Space%20Constraints/add_space_constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Space%20Constraints/edit_space_constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Space%20Constraints/space_constraint_details.dart'; // Import the details page
import 'package:smarn/services/constraint_service.dart';

class SpaceConstraintsView extends StatefulWidget {
  const SpaceConstraintsView({super.key});

  @override
  _SpaceConstraintsViewState createState() => _SpaceConstraintsViewState();
}

class _SpaceConstraintsViewState extends State<SpaceConstraintsView> {
  final ConstraintService _constraintService = ConstraintService();
  List<SpaceConstraint> _constraints = [];

  @override
  void initState() {
    super.initState();
    _fetchConstraints();
  }

  Future<void> _fetchConstraints() async {
    var allConstraints = await _constraintService.getAllConstraints();
    setState(() {
      // Filter the constraints to include only SpaceConstraint
      _constraints = allConstraints
          .where((constraint) => constraint is SpaceConstraint)
          .cast<SpaceConstraint>()
          .toList();
    });
  }

  void _navigateToEdit(SpaceConstraint constraint) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSpaceConstraintView(constraint: constraint),
      ),
    ).then((_) => _fetchConstraints()); // Refresh data after editing
  }

  void _deleteConstraint(SpaceConstraint constraint) async {
    // Show confirmation dialog before deleting
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Constraint'),
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

    if (confirmDelete == true) {
      // Proceed with deletion
      await _constraintService.deleteConstraint(constraint.id!); // Assuming deleteConstraint is implemented in the service
      _fetchConstraints(); // Refresh the list after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Space Constraints"),
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
                      onEdit: () => _navigateToEdit(_constraints[index]),
                      onDelete: () => _deleteConstraint(_constraints[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add space constraint form
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSpaceConstraintView(),
            ),
          ).then((_) => _fetchConstraints());
        },
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildConstraintCard({
    required SpaceConstraint constraint,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return InkWell(
      onTap: () {
        // Navigate to space constraint details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpaceConstraintDetails(
              constraint: constraint,
            ),
          ),
        );
      },
      child: Card(
        color: const Color.fromARGB(255, 34, 34, 34),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title of the constraint
                    Text(
                      'Space Constraint: ${constraint.type.name}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Display the ID and Type of the constraint
                    Text(
                      'ID: ${constraint.id ?? "Unknown"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Type: ${constraint.type.toString().split('.').last}',
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
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Color.fromARGB(255, 248, 52, 52)),
                    onPressed: onDelete,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: () {
                      // Navigate to details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpaceConstraintDetails(
                            constraint: constraint,
                          ),
                        ),
                      );
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
