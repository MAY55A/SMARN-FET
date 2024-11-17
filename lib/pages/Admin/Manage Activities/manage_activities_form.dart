import 'package:flutter/material.dart';
import 'add_activity.dart'; // Import the AddActivity screen
import 'edit_activity.dart'; // Import the EditActivity screen

class ManageActivitiesForm extends StatefulWidget {
  const ManageActivitiesForm({Key? key}) : super(key: key);

  @override
  _ManageActivitiesFormState createState() => _ManageActivitiesFormState();
}

class _ManageActivitiesFormState extends State<ManageActivitiesForm> {
  // Static data (activities)
  List<Map<String, dynamic>> activities = [
    {
      'id': '1',
      'name': 'Math Lecture',
      'subject': 'Math',
      'teacher': 'Mr. John',
      'className': 'Class A',
      'isActive': true,
      'duration': 60,
      'tag': 'Lecture',
      'room': '101',
    },
    {
      'id': '2',
      'name': 'Science Lab',
      'subject': 'Science',
      'teacher': 'Mrs. Smith',
      'className': 'Class B',
      'isActive': true,
      'duration': 120,
      'tag': 'Practical',
      'room': '102',
    },
    {
      'id': '3',
      'name': 'English Workshop',
      'subject': 'English',
      'teacher': 'Ms. Emily',
      'className': 'Class C',
      'isActive': false,
      'duration': 90,
      'tag': 'Workshop',
      'room': '201',
    },
    // More activities...
  ];

  List<Map<String, dynamic>> filteredActivities = []; // List to hold filtered activities
  String filterName = ''; // Filter for name
  String? filterClass; // Filter for class
  String? filterTeacher; // Filter for teacher
  String? filterTag; // Filter for tag

  @override
  void initState() {
    super.initState();
    // Initially show all activities
    filteredActivities = activities;
  }

  // Function to filter activities based on the current filters
  void _filterActivities() {
    setState(() {
      filteredActivities = activities
          .where((activity) {
            bool matchesName = activity['name']
                .toLowerCase()
                .contains(filterName.toLowerCase());
            bool matchesClass = filterClass == null || filterClass == 'All' || activity['className'] == filterClass;
            bool matchesTeacher = filterTeacher == null || filterTeacher == 'All' || activity['teacher'] == filterTeacher;
            bool matchesTag = filterTag == null || filterTag == 'All' || activity['tag'] == filterTag;
            return matchesName && matchesClass && matchesTeacher && matchesTag;
          })
          .toList();
    });
  }

  // Function to handle edit activity and navigate to EditActivity
  void _editActivity(Map<String, dynamic> activity) async {
    final updatedActivity = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditActivity(activity: activity),
      ),
    );

    if (updatedActivity != null) {
      setState(() {
        int index = activities.indexWhere((a) => a['id'] == updatedActivity['id']);
        if (index != -1) {
          activities[index] = updatedActivity;
        }
      });
    }
  }

  // Function to handle delete activity
  void _deleteActivity(Map<String, dynamic> activity) {
    setState(() {
      filteredActivities.remove(activity);
    });
    print("Deleted Activity: ${activity['name']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manage Activities'),
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
                // Search Bar for Activity Name and Filters combined
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      filterName = value;
                      _filterActivities(); // Filter by name
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
          // Filters Section - Class, Teacher, Tag
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text("Class", style: TextStyle(color: Colors.white)),
                    value: filterClass,
                    onChanged: (String? newValue) {
                      setState(() {
                        filterClass = newValue;
                        _filterActivities(); // Apply the class filter
                      });
                    },
                    items: ['All', 'Class A', 'Class B', 'Class C']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    dropdownColor: Colors.black,
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text("Teacher", style: TextStyle(color: Colors.white)),
                    value: filterTeacher,
                    onChanged: (String? newValue) {
                      setState(() {
                        filterTeacher = newValue;
                        _filterActivities(); // Apply the teacher filter
                      });
                    },
                    items: ['All', 'Mr. John', 'Mrs. Smith', 'Ms. Emily']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    dropdownColor: Colors.black,
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text("Tag", style: TextStyle(color: Colors.white)),
                    value: filterTag,
                    onChanged: (String? newValue) {
                      setState(() {
                        filterTag = newValue;
                        _filterActivities(); // Apply the tag filter
                      });
                    },
                    items: ['All', 'lecture', 'lab', 'seminar', 'workshop', 'exam', 'other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    dropdownColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // List of Filtered Activities
          Expanded(
            child: ListView.builder(
              itemCount: filteredActivities.length,
              itemBuilder: (context, index) {
                final activity = filteredActivities[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: const Color.fromARGB(255, 34, 34, 34),
                  child: ListTile(
                    title: Text(activity['name'], style: const TextStyle(color: Colors.white)),
                    subtitle: Text(
                        'Teacher: ${activity['teacher']}, Class: ${activity['className']}',
                        style: const TextStyle(color: Colors.white)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Icon
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () => _editActivity(activity),
                        ),
                        // Delete Icon
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _deleteActivity(activity),
                        ),
                      ],
                    ),
                    onTap: () {
                      print("Activity tapped: ${activity['name']}");
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Floating Action Button to Add Activities
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddActivity form
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddActivity()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
    );
  }
}
