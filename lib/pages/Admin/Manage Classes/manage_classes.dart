import 'package:flutter/material.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/services/class_service.dart'; // Import ClassService
import 'add_class.dart'; // Import the AddClass screen
import 'edit_class.dart'; // Import the EditClass screen

class ManageClasses extends StatefulWidget {
  const ManageClasses({super.key});

  @override
  State<ManageClasses> createState() => _ManageClassesState();
}

class _ManageClassesState extends State<ManageClasses> {
  List<Class> classes = [];
  List<Class> filteredClasses = [];
  String filterName = ''; // Filter for class name
  final ClassService _classService = ClassService();

  @override
  void initState() {
    super.initState();
    _fetchClasses(); // Fetch classes when the screen is loaded
  }

  // Fetch classes dynamically from the backend
  Future<void> _fetchClasses() async {
    try {
      List<Class> fetchedClasses = await _classService.getAllClasses();
      setState(() {
        classes = fetchedClasses;
        filteredClasses = classes; // Initially show all classes
      });
    } catch (e) {
      print('Error fetching classes: $e');
    }
  }

  // Function to filter classes based on the current filters
  void _filterClasses() {
    setState(() {
      filteredClasses = classes
          .where((classItem) =>
              classItem.name.toLowerCase().contains(filterName.toLowerCase()))
          .toList();
    });
  }

  // Function to handle edit class and navigate to EditClass
  void _editClass(Class classItem) async {
    final updatedClass = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditClass(classItem: classItem),
      ),
    );

    if (updatedClass != null) {
      setState(() {
        int index = classes.indexWhere((c) => c.id == updatedClass.id);
        if (index != -1) {
          classes[index] = updatedClass;
        }
        _filterClasses(); // Reapply the filter after editing
      });
    }
  }

  // Function to handle delete class with a confirmation dialog
  void _confirmDelete(Class classItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Class'),
        content: Text(
            'Are you sure you want to delete the class "${classItem.name}"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              _deleteClass(classItem); // Proceed with deletion
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Function to handle delete class
  void _deleteClass(Class classItem) async {
    final result = await _classService.deleteClass(classItem.id!);
    if (result['success']) {
      setState(() {
        filteredClasses.remove(classItem);
        classes.remove(classItem);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Class "${classItem.name}" deleted successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting class: ${result['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manage Classes'),
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
                // Search Bar for Class Name
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      filterName = value;
                      _filterClasses(); // Filter by name
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
                SizedBox(
                    width: 5), // Space between search bar and filter dropdowns
              ],
            ),
          ),
          // List of Filtered Classes
          Expanded(
            child: filteredClasses.isEmpty
                ? const Center(
                    child: Text(
                      'No classes found',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredClasses.length,
                    itemBuilder: (context, index) {
                      final classItem = filteredClasses[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        color: const Color.fromARGB(255, 34, 34, 34),
                        child: ListTile(
                          title: Text(classItem.name,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(
                              'Students: ${classItem.nbStudents}, Access Key: ${classItem.accessKey}',
                              style: const TextStyle(color: Colors.white)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit Icon
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                onPressed: () => _editClass(classItem),
                              ),
                              // Delete Icon with Confirmation
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () => _confirmDelete(classItem),
                              ),
                            ],
                          ),
                          onTap: () {
                            print("Class tapped: ${classItem.name}");
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // Floating Action Button to Add Classes
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddClass form
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddClass()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
    );
  }
}
