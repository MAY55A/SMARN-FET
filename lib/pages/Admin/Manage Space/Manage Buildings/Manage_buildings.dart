import 'package:flutter/material.dart';
import 'package:smarn/models/building.dart';
import 'add_building.dart'; // Import AddBuilding screen
import 'edit_building.dart'; // Import EditBuilding screen

class ManageBuildings extends StatefulWidget {
  const ManageBuildings({super.key});

  @override
  State<ManageBuildings> createState() => _ManageBuildingsState();
}

class _ManageBuildingsState extends State<ManageBuildings> {
  // Static data for buildings
  List<Building> buildings = [
    Building(
      id: '1',
      name: 'Building A',
      longName: 'Administration Building',
      description: 'Main administration offices',
    ),
    Building(
      id: '2',
      name: 'Building B',
      longName: 'Science Block',
      description: 'Science and research facilities',
    ),
    Building(
      id: '3',
      name: 'Building C',
      longName: 'Library',
      description: 'Central library with digital resources',
    ),
  ];

  List<Building> filteredBuildings = []; // Filtered list of buildings
  String filterName = ''; // Filter for building name

  @override
  void initState() {
    super.initState();
    filteredBuildings = buildings; // Initially show all buildings
  }

  // Function to filter buildings based on the current filters
  void _filterBuildings() {
    setState(() {
      filteredBuildings = buildings
          .where((building) => building.name.toLowerCase().contains(filterName.toLowerCase()))
          .toList();
    });
  }

  // Function to handle edit building and navigate to EditBuilding
  void _editBuilding(Building building) async {
    final updatedBuilding = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBuilding(building: building),
      ),
    );

    if (updatedBuilding != null) {
      setState(() {
        int index = buildings.indexWhere((b) => b.id == updatedBuilding.id);
        if (index != -1) {
          buildings[index] = updatedBuilding;
        }
      });
    }
  }

  // Function to handle delete building
  void _deleteBuilding(Building building) {
    setState(() {
      filteredBuildings.remove(building);
      buildings.remove(building);
    });
    print("Deleted Building: ${building.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manage Buildings'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Section combined with Search
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Search Bar for Building Name
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      filterName = value;
                      _filterBuildings(); // Filter by name
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Search...',
                      labelStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List of Filtered Buildings
          Expanded(
            child: ListView.builder(
              itemCount: filteredBuildings.length,
              itemBuilder: (context, index) {
                final building = filteredBuildings[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: const Color.fromARGB(255, 34, 34, 34),
                  child: ListTile(
                    title: Text(building.name, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(
                        '${building.longName}: ${building.description}',
                        style: const TextStyle(color: Colors.white)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Icon
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () => _editBuilding(building),
                        ),
                        // Delete Icon
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _deleteBuilding(building),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Floating Action Button to Add Buildings
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddBuilding form
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBuilding()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
    );
  }
}
