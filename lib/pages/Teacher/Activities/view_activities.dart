import 'package:flutter/material.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/pages/widgets/dropDownMenu.dart';
import 'package:smarn/services/activity_service.dart';
import 'package:smarn/services/auth_service.dart';
import 'package:smarn/services/class_service.dart';

class ViewActivities extends StatefulWidget {
  const ViewActivities({Key? key}) : super(key: key);

  @override
  _ViewActivitiesState createState() => _ViewActivitiesState();
}

class _ViewActivitiesState extends State<ViewActivities> {
  final ActivityService _activityService = ActivityService();
  final ClassService _classService = ClassService();

  final List<String> tags = ActivityTag.values.map((t) => t.name).toList();

  List<Map<String, dynamic>> activities = [];
  List<Map<String, dynamic>> filteredActivities = [];
  List<String> classes = [];

  String filterName = '';
  String filterClass = 'All';
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

    await Future.wait([_fetchActivities(), _fetchClasses()]);

    setState(() {
      isLoading = false;
      isClassesLoading = false;
    });
  }

  Future<void> _fetchActivities() async {
    try {
      final fetchedActivities = await _activityService
          .getActivitiesByTeacher(AuthService().getCurrentUser()!.uid);
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

  void _filterActivities() {
    setState(() {
      filteredActivities = activities.where((activity) {
        bool matchesName = activity["subject"]["longName"]
                .toLowerCase()
                .contains(filterName.toLowerCase()) ||
            activity["subject"]["name"]
                .toLowerCase()
                .contains(filterName.toLowerCase());
        bool matchesClass = filterClass == null ||
            filterClass == 'All' ||
            activity["studentsClass"]["name"] == filterClass;
        bool matchesTag = filterTag == null ||
            filterTag == 'All' ||
            activity["tag"].toLowerCase() == filterTag;

        return matchesName && matchesClass && matchesTag;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Activities'),
        backgroundColor: Colors.blue,
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
                    filterMenu(classes, filterClass, "classes", (String value) {
                      filterClass = value;
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
                                'On ${activity['day'] ?? "??"} ${activity['startTime'] ?? "??"}h --> ${activity['endTime'] ?? "??"}h',
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Text(
                                  "${activity['room']?['name'] ?? "no assigned room"}",
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
