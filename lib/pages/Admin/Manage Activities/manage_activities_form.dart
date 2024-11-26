import 'package:flutter/material.dart';
import 'package:smarn/models/activity.dart';
import 'package:smarn/services/activity_service.dart';
import 'package:smarn/services/class_service.dart';
import 'add_activity.dart';
import 'edit_activity.dart';
import 'package:smarn/models/class.dart';

class ManageActivitiesForm extends StatefulWidget {
  const ManageActivitiesForm({super.key});

  @override
  _ManageActivitiesFormState createState() => _ManageActivitiesFormState();
}

class _ManageActivitiesFormState extends State<ManageActivitiesForm> {
  final ActivityService _activityService = ActivityService();
  final ClassService _classService = ClassService();

<<<<<<< HEAD
  List<Map<String, dynamic>> filteredActivities =
      []; // List to hold filtered activities
  String filterName = ''; // Filter for name
  String? filterClass; // Filter for class
  String? filterTeacher; // Filter for teacher
  String? filterTag; // Filter for tag
=======
  List<Activity> activities = [];
  List<Activity> filteredActivities = [];
  List<Class> classes = [];
  List<String> teachers = [];
  List<String> tags = ['All', 'lecture', 'lab', 'workshop', 'exam', 'other'];

  String filterName = '';
  String? filterClass = 'All';
  String? filterTeacher = 'All';
  String? filterTag = 'All';

  bool isLoading = true;
  bool isClassesLoading = true;
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
<<<<<<< HEAD
      filteredActivities = activities.where((activity) {
        bool matchesName =
            activity['name'].toLowerCase().contains(filterName.toLowerCase());
        bool matchesClass = filterClass == null ||
            filterClass == 'All' ||
            activity['className'] == filterClass;
        bool matchesTeacher = filterTeacher == null ||
            filterTeacher == 'All' ||
            activity['teacher'] == filterTeacher;
        bool matchesTag = filterTag == null ||
            filterTag == 'All' ||
            activity['tag'] == filterTag;
        return matchesName && matchesClass && matchesTeacher && matchesTag;
      }).toList();
=======
      isLoading = true;
      isClassesLoading = true;
    });

    await Future.wait([_fetchActivities(), _fetchClasses()]);
    _extractFilters();

    setState(() {
      isLoading = false;
      isClassesLoading = false;
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
    });
  }

  Future<void> _fetchActivities() async {
    try {
      final fetchedActivities = await _activityService.getAllActivities();
      setState(() {
        activities = fetchedActivities;
        filteredActivities = activities;
      });
    } catch (e) {
      print('Error fetching activities: $e');
    }
  }

  Future<void> _fetchClasses() async {
    try {
      final fetchedClasses = await _classService.getAllclasses();
      setState(() {
        classes = fetchedClasses;
      });
    } catch (e) {
      print('Error fetching classes: $e');
    }
  }

  void _extractFilters() {
    teachers = ['All'];
    for (var activity in activities) {
      if (!teachers.contains(activity.teacher)) {
        teachers.add(activity.teacher);
      }
    }
  }

  void _filterActivities() {
    setState(() {
      filteredActivities = activities.where((activity) {
        bool matchesName =
            activity.subject.toLowerCase().contains(filterName.toLowerCase());
        bool matchesClass = filterClass == null ||
            filterClass == 'All' ||
            activity.studentsClass == filterClass;
        bool matchesTeacher = filterTeacher == null ||
            filterTeacher == 'All' ||
            activity.teacher == filterTeacher;
        bool matchesTag = filterTag == null ||
            filterTag == 'All' ||
            activity.tag.toString().split('.').last.toLowerCase() == filterTag;

        return matchesName && matchesClass && matchesTeacher && matchesTag;
      }).toList();
    });
  }

  void _editActivity(Activity activity) async {
    final updatedActivity = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditActivity(activity: activity.toMap())),
    );

    if (updatedActivity != null) {
      setState(() {
<<<<<<< HEAD
        int index =
            activities.indexWhere((a) => a['id'] == updatedActivity['id']);
=======
        int index = activities.indexWhere((a) => a.id == updatedActivity.id);
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
        if (index != -1) {
          activities[index] = updatedActivity;
          _filterActivities();
        }
      });
    }
  }

  void _deleteActivity(Activity activity) async {
    final result = await _activityService.deleteActivity(activity.id!);
    if (result['success']) {
      setState(() {
        activities.remove(activity);
        filteredActivities.remove(activity);
      });
    } else {
      print('Error deleting activity: ${result['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manage Activities'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Column(
        children: [
          // Search and Filters
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    filterName = value;
                    _filterActivities();
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Search...',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: filterClass,
                        hint: const Text("Class",
                            style: TextStyle(color: Colors.white)),
                        onChanged: (String? newValue) {
                          filterClass = newValue;
                          _filterActivities();
                        },
                        items:
                            ['All', ...classes.map((c) => c.name)].map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        dropdownColor: Colors.black,
                      ),
                    ),
<<<<<<< HEAD
                  ),
                ),
                const SizedBox(
                    width: 5), // Space between search bar and filter dropdowns
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
                    hint: const Text("Class",
                        style: TextStyle(color: Colors.white)),
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
                        child: Text(value,
                            style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    dropdownColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text("Teacher",
                        style: TextStyle(color: Colors.white)),
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
                        child: Text(value,
                            style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    dropdownColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text("Tag",
                        style: TextStyle(color: Colors.white)),
                    value: filterTag,
                    onChanged: (String? newValue) {
                      setState(() {
                        filterTag = newValue;
                        _filterActivities(); // Apply the tag filter
                      });
                    },
                    items: [
                      'All',
                      'lecture',
                      'lab',
                      'seminar',
                      'workshop',
                      'exam',
                      'other'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    dropdownColor: Colors.black,
                  ),
=======
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        value: filterTeacher,
                        hint: const Text("Teacher",
                            style: TextStyle(color: Colors.white)),
                        onChanged: (String? newValue) {
                          filterTeacher = newValue;
                          _filterActivities();
                        },
                        items: teachers.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        dropdownColor: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        value: filterTag,
                        hint: const Text("Tag",
                            style: TextStyle(color: Colors.white)),
                        onChanged: (String? newValue) {
                          filterTag = newValue;
                          _filterActivities();
                        },
                        items: tags.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        dropdownColor: Colors.black,
                      ),
                    ),
                  ],
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                ),
              ],
            ),
          ),
          // Activities List
          Expanded(
<<<<<<< HEAD
            child: ListView.builder(
              itemCount: filteredActivities.length,
              itemBuilder: (context, index) {
                final activity = filteredActivities[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: const Color.fromARGB(255, 34, 34, 34),
                  child: ListTile(
                    title: Text(activity['name'],
                        style: const TextStyle(color: Colors.white)),
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
=======
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredActivities.length,
                    itemBuilder: (context, index) {
                      final activity = filteredActivities[index];
                      return Card(
                        color: const Color.fromARGB(255, 34, 34, 34),
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(activity.subject,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(
                            'Teacher: ${activity.teacher}, Class: ${activity.studentsClass}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                onPressed: () => _editActivity(activity),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () => _deleteActivity(activity),
                              ),
                            ],
                          ),
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddActivity()));
        },
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        child: const Icon(Icons.add),
      ),
    );
  }
}
