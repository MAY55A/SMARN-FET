import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarn/pages/Teacher/Manage%20qualified%20subjects/add_subject.dart';
import 'package:smarn/services/auth_service.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/services/subject_service.dart'; // Importing SubjectService
import 'package:smarn/pages/widgets/canstants.dart';

class ManageQualifiedSubjectsForm extends StatefulWidget {
  @override
  _ManageQualifiedSubjectsFormState createState() =>
      _ManageQualifiedSubjectsFormState();
}

class _ManageQualifiedSubjectsFormState
    extends State<ManageQualifiedSubjectsForm> {
  final TeacherService _teacherService = TeacherService();
  final SubjectService _subjectService = SubjectService();
  User? currentTeacher = AuthService().getCurrentUser();
  List<String> _subjectIds = []; // List of Subject IDs
  Map<String, String> _subjectNames =
      {}; // Map to store Subject names by their IDs
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeacherData();
  }

  Future<void> _fetchTeacherData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final teacher = await _teacherService.fetchTeacherData();

      if (teacher != null) {
        setState(() {
          _subjectIds = teacher.subjects;
          _isLoading = false;
        });

        // Now fetch the subject details (names) for all subject IDs
        await _fetchSubjectNames();
      } else {
        throw Exception("Teacher data could not be retrieved.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching teacher data: $e")),
      );
    }
  }

  // Fetch subject details and store them in _subjectNames
  Future<void> _fetchSubjectNames() async {
    for (String subjectId in _subjectIds) {
      final subject = await _subjectService.getSubjectDetails(subjectId);
      if (subject != null) {
        setState(() {
          _subjectNames[subjectId] =
              "${subject.longName} \n${subject.name}"; // Map the ID to the subject name
        });
      }
    }
  }

  // Show confirmation dialog for deleting a subject
  Future<void> _showDeleteConfirmationDialog(String subjectId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(
              255, 30, 30, 30), // Black background for the dialog
          title: const Text(
            "Are you sure?",
            style: TextStyle(color: Colors.white), // White title text
          ),
          content: const Text(
            "Do you want to remove this subject from your list of qualified subjects ?",
            style: TextStyle(color: Colors.white), // White content text
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Cancel",
                style:
                    TextStyle(color: Colors.white), // White text for the button
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteSubject(subjectId); // Proceed to delete the subject
              },
              child: const Text(
                "Confirm",
                style:
                    TextStyle(color: Colors.white), // White text for the button
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSubject(String subjectId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final updatedSubjects =
          _subjectIds.where((subject) => subject != subjectId).toList();

      final result = await _teacherService.updateTeacherSubjects(
          currentTeacher!.uid, updatedSubjects);

      if (result['success']) {
        _fetchTeacherData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Subject removed successfully")),
        );
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error removing subject: $e")),
      );
    }
  }

  Future<void> _addSubjects(List<String> selectedSubjectIds) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final updatedSubjects = [
        ..._subjectIds,
        ...selectedSubjectIds,
      ];

      final result = await _teacherService.updateTeacherSubjects(
          currentTeacher!.uid, updatedSubjects);

      if (result['success']) {
        _fetchTeacherData();
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding subjects: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Qualified Subjects"),
        backgroundColor: Colors.blue, // Blue app bar
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Qualified Subjects",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _subjectIds.length,
                        itemBuilder: (context, index) {
                          final subjectId = _subjectIds[index];
                          final subjectName =
                              _subjectNames[subjectId] ?? "Unknown Subject";

                          return Card(
                            color: AppColors.formColor,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading: const Icon(
                                Icons.book,
                                color: Colors.blue,
                              ),
                              title: Text(
                                subjectName,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              subtitle: Text(
                                "ID: $subjectId",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(221, 184, 220, 240),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.highlight_remove,
                                    color: Colors.red),
                                onPressed: () =>
                                    _showDeleteConfirmationDialog(subjectId),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push<List<String>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectSubjectScreen(),
                          ),
                        );
                        if (result != null && result.isNotEmpty) {
                          _addSubjects(result);
                        }
                      },
                      child: const Text("Add Subject"),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue), // Blue button
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
