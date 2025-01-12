import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Space%20Constraints/add_space_constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Space%20Constraints/edit_space_constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Space%20Constraints/space_constraint_details.dart'; // Import the details page
import 'package:smarn/pages/widgets/delete_confirmation_dialog.dart';
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

  void _deleteSpaceConstraint(String constraintId) async {
    try {
      final result = await _constraintService.deleteConstraint(constraintId);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Space constraint deleted successfully.')),
        );
        _fetchConstraints(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete space constraint.')),
        );
      }
    } catch (e) {
      print('Error deleting space constraint: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while deleting.')),
      );
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
                        onDelete: () => showDeleteConfirmationDialog(
                            context,
                            "space constraint",
                            () => _deleteSpaceConstraint(
                                _constraints[index].id!)));
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
                    icon: const Icon(Icons.delete,
                        color: Color.fromARGB(255, 248, 52, 52)),
                    onPressed: onDelete,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
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
