import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Space%20Constraints/add_space_constraint.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Space%20Constraints/edit_space_constraint.dart';
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
    _constraints = (await _constraintService.getAllConstraints()).cast<SpaceConstraint>();
    setState(() {});
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
                      onTap: () {
                        // Navigate to edit space constraint
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditSpaceConstraintView(
                              constraint: _constraints[index],
                            ),
                          ),
                        ).then((_) => _fetchConstraints());
                      },
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
              const Icon(Icons.location_on, color: Colors.white, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Space Constraint: ${constraint.type.name}',
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
                    onPressed: onTap,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      // Delete constraint logic here
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.white),
                    onPressed: () {
                      // View constraint details logic here
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
