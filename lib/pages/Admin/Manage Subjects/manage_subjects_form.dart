import 'package:flutter/material.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/subject_service.dart';
import 'add_subject.dart';
import 'edit_subject.dart';

class ManageSubjectsForm extends StatefulWidget {
  const ManageSubjectsForm({Key? key}) : super(key: key);

  @override
  _ManageSubjectsFormState createState() => _ManageSubjectsFormState();
}

class _ManageSubjectsFormState extends State<ManageSubjectsForm> {
  final SubjectService _subjectService = SubjectService();
  List<Subject> subjects = [];
  List<Subject> filteredSubjects = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
    _searchController.addListener(_filterSubjects);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterSubjects);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchSubjects() async {
    try {
      setState(() {
        isLoading = true;
      });
      final fetchedSubjects = await _subjectService.getAllSubjects();
      setState(() {
        subjects = fetchedSubjects;
        filteredSubjects = subjects; // Initialize filtered list
      });
    } catch (e) {
      print("Error fetching subjects: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterSubjects() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredSubjects = subjects
          .where((subject) => subject.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _addSubject() async {
    final newSubject = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddSubject()),
    );

    if (newSubject != null) {
      setState(() {
        subjects.add(newSubject);
        _filterSubjects();
      });
    }
  }

  void _editSubject(Subject subject) async {
    final updatedSubject = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSubjectForm(subject: subject),
      ),
    );

    if (updatedSubject != null) {
      setState(() {
        int index = subjects.indexWhere((s) => s.id == updatedSubject.id);
        if (index != -1) {
          subjects[index] = updatedSubject;
          _filterSubjects();
        }
      });
    }
  }

  Future<void> _confirmDeleteSubject(Subject subject) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete the subject "${subject.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _deleteSubject(subject);
    }
  }

  Future<void> _deleteSubject(Subject subject) async {
    try {
      final response = await _subjectService.deleteSubject(subject.id!);
      if (response['success']) {
        setState(() {
          subjects.remove(subject);
          _filterSubjects();
        });
      } else {
        print("Failed to delete subject: ${response['message']}");
      }
    } catch (e) {
      print("Error deleting subject: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Subjects", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.appBarColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: AppColors.backgroundColor,
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search subjects...',
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  // Subject List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredSubjects.length,
                      itemBuilder: (context, index) {
                        final subject = filteredSubjects[index];
                        return Card(
                          color: const Color.fromARGB(255, 44, 44, 44),
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              subject.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              subject.longName ?? '',
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white),
                                  onPressed: () => _editSubject(subject),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  onPressed: () => _confirmDeleteSubject(subject),
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSubject,
        backgroundColor: AppColors.appBarColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}