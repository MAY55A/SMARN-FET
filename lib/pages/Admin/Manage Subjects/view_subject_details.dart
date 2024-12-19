import 'package:flutter/material.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/teacher_service.dart';

class ViewSubjectDetails extends StatefulWidget {
  final Subject subject;
  const ViewSubjectDetails({Key? key, required this.subject}) : super(key: key);

  @override
  _ViewSubjectDetailsState createState() => _ViewSubjectDetailsState();
}

class _ViewSubjectDetailsState extends State<ViewSubjectDetails> {
  final TeacherService _teacherService = TeacherService();
  bool _isLoading = true;
  List<Teacher> _teachers = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTeachersForSubject();
  }

  Future<void> _loadTeachersForSubject() async {
    try {
      // Fetch the list of teachers who teach the subject
      var teachersList =
          await _teacherService.getTeachersBySubject(widget.subject.id!);

      // Check if the teachersList is not empty
      if (teachersList.isNotEmpty) {
        setState(() {
          _teachers = teachersList
              .map((teacherData) {
                // Ensure that teacherData contains valid 'teacher' data
                if (teacherData['teacher'] != null) {
                  return Teacher.fromMap(teacherData['teacher'] as Map<String, dynamic>);
                }
                return null; // If no valid teacher data, return null
              })
              .whereType<
                  Teacher>() // This ensures only non-null Teacher objects are included
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No teachers found for this subject';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        // Catch the error and display it in the UI
        _errorMessage = 'Error fetching teachers for this subject: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Subject Details",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.subject.name}',
                style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Text('Long Name: ${widget.subject.longName ?? 'Not Provided'}',
                style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Text('Description: ${widget.subject.description ?? 'Not Provided'}',
                style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 20),
            const Text('Teachers:',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                      ? Center(
                          child: Text(_errorMessage,
                              style: const TextStyle(color: Colors.red)))
                      : _teachers.isEmpty
                          ? const Center(
                              child: Text('No teachers found for this subject.',
                                  style: TextStyle(color: Colors.white)))
                          : ListView.builder(
                              itemCount: _teachers.length,
                              itemBuilder: (context, index) {
                                final teacher = _teachers[index];
                                return ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  title: Text(teacher.name,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  subtitle: Text(
                                      teacher.email ?? 'No email provided',
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  leading: teacher.picture.isNotEmpty
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(teacher.picture))
                                      : const CircleAvatar(
                                          child: Icon(Icons.person)),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
