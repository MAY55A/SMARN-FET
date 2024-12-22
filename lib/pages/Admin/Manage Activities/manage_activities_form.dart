import 'package:flutter/material.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/pages/widgets/dropDownMenu.dart';
import 'package:smarn/services/activity_service.dart';
import 'package:smarn/services/class_service.dart';
import 'package:smarn/services/teacher_service.dart';
import 'add_activity.dart';
import 'edit_activity.dart';

class ManageActivitiesForm extends StatefulWidget {
  const ManageActivitiesForm({Key? key}) : super(key: key);

  @override
  _ManageActivitiesFormState createState() => _ManageActivitiesFormState();
}

class _ManageActivitiesFormState extends State<ManageActivitiesForm> {
  final ActivityService _activityService = ActivityService();
  final ClassService _classService = ClassService();
  final TeacherService _teacherService = TeacherService();

  final List<String> tags = ActivityTag.values.map((t) => t.name).toList();

  List<Map<String, dynamic>> activities = [];
  List<Map<String, dynamic>> filteredActivities = [];
  List<String> classes = [];
  List<String> teachers = [];

  String filterName = '';
  String filterClass = 'All';
  String filterTeacher = 'All';
  String filterTag = 'All';

  bool isLoading = true;
  bool isClassesLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      isClassesLoading = true;
    });

    await Future.wait([_fetchActivities(), _fetchClasses(), _fetchTeachers()]);

    setState(() {
      isLoading = false;
      isClassesLoading = false;
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
      final fetchedClasses = await _classService.getAllClassesNames();
      setState(() {
        classes = fetchedClasses;
      });
    } catch (e) {
      print('Error fetching classes: $e');
    }
  }

  Future<void> _fetchTeachers() async {
    try {
      final fetchedTeachers = await _teacherService.getAllTeachersNames();
      setState(() {
        teachers = fetchedTeachers;
      });
    } catch (e) {
      print('Error fetching classes: $e');
    }
  }

  void _filterActivities() {
    setState(() {
      filteredActivities = activities.where((activity) {
        bool matchesName = activity["subject"]["longName"]
                .toLowerCase()
                .contains(filterName.toLowerCase()) ||
            activity["subject"]["name"]
                .toLowerCase()
                .contains(filterName.toLowerCase());
        bool matchesClass = filterClass == 'All' ||
            activity["studentsClass"]["name"] == filterClass;
        bool matchesTag = filterTag == 'All' ||
            activity["tag"].toLowerCase() == filterTag;
        bool matchesTeacher = filterTeacher == 'All' ||
            activity["teacher"]["name"] == filterTeacher;

        return matchesName && matchesClass && matchesTeacher && matchesTag;
      }).toList();
    });
  }

  void _editActivity(Map<String, dynamic> activity) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditActivity(activity: activity)),
    );

    if (updated != null && updated) {
      setState(() {
        _fetchActivities();
      });
    }
  }

  void _deleteActivity(Map<String, dynamic> activity) async {
    final result = await _activityService.deleteActivity(activity["id"]);
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
                    const SizedBox(width: 8),
                    filterMenu(classes, filterClass, "classes", (String value) {
                      filterClass = value;
                      _filterActivities();
                    }),
                    const SizedBox(width: 8),
                    filterMenu(teachers, filterTeacher, "teachers",
                        (String value) {
                      filterTeacher = value;
                      _filterActivities();
                    }),
                    const SizedBox(width: 8),
                    filterMenu(tags, filterTag, "tags", (String value) {
                      filterTag = value;
                      _filterActivities();
                    }),
                  ],
                ),
              ],
            ),
          ),
          // Activities List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredActivities.isEmpty
                    ? const Center(
                        child: Text(
                          'No activities found',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredActivities.length,
                        itemBuilder: (context, index) {
                          final activity = filteredActivities[index];

                          return Card(
                            color: const Color.fromARGB(255, 34, 34, 34),
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                  "${activity['subject']['longName']} - ${activity["studentsClass"]["name"]}",
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(
                                'Duration: ${activity['duration']} minutes\nTeacher: ${activity["teacher"]["name"]}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white),
                                    onPressed: () => _editActivity(activity),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.white),
                                    onPressed: () => _deleteActivity(activity),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddActivity()));
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
    );
  }
}
