import 'package:flutter/material.dart';
import 'package:smarn/models/class.dart';
import 'add_class.dart'; // Import the AddClass screen
import 'edit_class.dart'; // Import the EditClass screen

class ManageClasses extends StatefulWidget {
  const ManageClasses({super.key});

  @override
  State<ManageClasses> createState() => _ManageClassesState();
}

class _ManageClassesState extends State<ManageClasses> {
  // Static data (classes)
  List<Class> classes = [
    Class(id: '1', name: 'Class A', longName: 'Mathematics Class A', nbStudents: 30, accessKey: 'abc123'),
    Class(id: '2', name: 'Class B', longName: 'Science Class B', nbStudents: 25, accessKey: 'xyz456'),
    Class(id: '3', name: 'Class C', longName: 'English Class C', nbStudents: 20, accessKey: 'efg789'),
  ];

  List<Class> filteredClasses = []; // List to hold filtered classes
  String filterName = ''; // Filter for class name

  @override
  void initState() {
    super.initState();
    // Initially show all classes
    filteredClasses = classes;
  }

  // Function to filter classes based on the current filters
  void _filterClasses() {
    setState(() {
      filteredClasses = classes
          .where((classItem) => classItem.name.toLowerCase().contains(filterName.toLowerCase()))
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
      });
    }
  }

  // Function to handle delete class
  void _deleteClass(Class classItem) {
    setState(() {
      filteredClasses.remove(classItem);
      classes.remove(classItem);
    });
    print("Deleted Class: ${classItem.name}");
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
                SizedBox(width: 5), // Space between search bar and filter dropdowns
              ],
            ),
          ),
          // List of Filtered Classes
          Expanded(
            child: ListView.builder(
              itemCount: filteredClasses.length,
              itemBuilder: (context, index) {
                final classItem = filteredClasses[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: const Color.fromARGB(255, 34, 34, 34),
                  child: ListTile(
                    title: Text(classItem.name, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(
                        'Students: ${classItem.nbStudents}, Access Key: ${classItem.accessKey}',
                        style: const TextStyle(color: Colors.white)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Icon
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () => _editClass(classItem),
                        ),
                        // Delete Icon
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _deleteClass(classItem),
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



