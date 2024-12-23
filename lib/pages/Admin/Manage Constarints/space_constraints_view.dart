import 'package:flutter/material.dart';

class SpaceConstraintsView extends StatefulWidget {
  const SpaceConstraintsView({super.key});

  @override
  _SpaceConstraintsViewState createState() => _SpaceConstraintsViewState();
}

class _SpaceConstraintsViewState extends State<SpaceConstraintsView> {
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
              // List of space constraints
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return _buildConstraintCard(
                      title: 'Space Constraint ${index + 1}',
                      icon: Icons.location_on,
                      onTap: () {
                        // Navigate to view/edit space constraint
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
                    onPressed: () {
                      // Navigate to edit constraint
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      // Delete constraint
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
            ],
          ),
        ),
      ),
    );
  }
}
