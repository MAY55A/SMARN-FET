import 'package:flutter/material.dart';
import 'package:smarn/services/subject_service.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/services/teacher_service.dart'; // Import TeacherService
import 'package:firebase_auth/firebase_auth.dart'; // For accessing the current teacher

class SelectSubjectScreen extends StatefulWidget {
  const SelectSubjectScreen({super.key});

  @override
  _SelectSubjectScreenState createState() => _SelectSubjectScreenState();
}

class _SelectSubjectScreenState extends State<SelectSubjectScreen> {
  late SubjectService _subjectService;
  late TeacherService _teacherService; // Declare TeacherService
  List<Subject> _allSubjects = [];
  List<String> _selectedSubjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _subjectService = SubjectService();
    _teacherService = TeacherService(); // Initialize TeacherService
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    try {
      final subjects = await _subjectService.getAllSubjects();
      setState(() {
        _allSubjects = subjects;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching subjects: $e")),
      );
    }
  }

  // Add selected subject IDs to the teacher's subjects
  Future<void> _updateTeacherSubjects() async {
    try {
      final teacherId = FirebaseAuth.instance.currentUser!.uid;
      final result = await _teacherService.updateTeacherSubjects(
        teacherId,
        _selectedSubjects,
      );

      if (result['success']) {
        Navigator.pop(context, _selectedSubjects); // Return the selected subject IDs
      } else {
        throw Exception("Failed to update teacher's subjects.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating teacher's subjects: $e")),
      );
    }
  }

  // Show confirmation dialog before updating the teacher's subjects
  Future<void> _showConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black, // Black background for the dialog
          title: const Text(
            "Are you sure?",
            style: TextStyle(color: Colors.white), // White title text
          ),
          content: const Text(
            "Do you want to add the selected subjects to your list?",
            style: TextStyle(color: Colors.white), // White content text
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white), // White text for the button
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _updateTeacherSubjects(); // Proceed to update subjects
              },
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.white), // White text for the button
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Subjects"),
        backgroundColor: Colors.blue, // Blue app bar
      ),
      backgroundColor:  const Color.fromARGB(255, 30, 30, 30), // Black background for the body
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _allSubjects.length,
              itemBuilder: (context, index) {
                final subject = _allSubjects[index];
                final isSelected = _selectedSubjects.contains(subject.id);
                return ListTile(
                  title: Text(
                    subject.name,
                    style: const TextStyle(color: Colors.white), // White text
                  ),
                  subtitle: Text(
                    "Code: ${subject.name}",
                    style: const TextStyle(color: Colors.white70), // White text with less opacity
                  ),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedSubjects.add(subject.id!); // Add subject ID
                        } else {
                          _selectedSubjects.remove(subject.id!); // Remove subject ID
                        }
                      });
                    },
                    activeColor: Colors.blue, // Blue checkbox when selected
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showConfirmationDialog, // Show the confirmation dialog
        child: const Icon(Icons.check),
        backgroundColor: Colors.blue, // Blue button
      ),
    );
  }
}
