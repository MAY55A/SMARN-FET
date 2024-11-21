import 'package:flutter/material.dart';
import 'package:smarn/models/building.dart';
import 'package:smarn/services/building_service.dart';
import 'add_building.dart'; // Import AddBuilding screen
import 'edit_building.dart'; // Import EditBuilding screen

class ManageBuildings extends StatefulWidget {
  const ManageBuildings({super.key});

  @override
  State<ManageBuildings> createState() => _ManageBuildingsState();
}

class _ManageBuildingsState extends State<ManageBuildings> {
  final BuildingService _buildingService = BuildingService();
  List<Building> buildings = []; // List of buildings fetched dynamically
  List<Building> filteredBuildings = [];
  String filterName = ''; // Filter for building name
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBuildings();
  }

  // Function to fetch buildings from the service
  Future<void> _fetchBuildings() async {
    setState(() {
      isLoading = true;
    });

    buildings = await _buildingService.getAllBuildings();
    filteredBuildings = buildings;

    setState(() {
      isLoading = false;
    });
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
        _filterBuildings();
      });
    }
  }

  // Function to confirm and delete a building
  void _deleteBuilding(Building building) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Building'),
          content: Text('Are you sure you want to delete "${building.name}"?'),
          actions: [
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

    if (confirm == true) {
      final result = await _buildingService.deleteBuilding(building.id!);
      if (result['success'] == true) {
        setState(() {
          buildings.removeWhere((b) => b.id == building.id);
          _filterBuildings();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Building "${building.name}" deleted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result['message']}')),
        );
      }
    }
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
          // Show loading spinner while data is being fetched
          if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
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
                        style: const TextStyle(color: Colors.white),
                      ),
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
        onPressed: () async {
          final newBuilding = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBuilding()),
          );

          if (newBuilding != null) {
            setState(() {
              buildings.add(newBuilding);
              _filterBuildings();
            });
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
    );
  }
}
