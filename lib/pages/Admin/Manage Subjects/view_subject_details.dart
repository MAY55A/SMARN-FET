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
      final teachersList =
          await _teacherService.getTeachersBySubject(widget.subject.id!);

      setState(() {
        _teachers = teachersList
            .map((teacherData) =>
                Teacher.fromMap(Map<String, dynamic>.from(teacherData)))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching teachers: $e';
        _isLoading = false;
      });
    }
  }

  Future<List<Teacher>> _filterTeachers(String subjectId) async {
    return _teachers.where((teacher) {
      return teacher.subjects.contains(subjectId);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Subject Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.grey[850],
            elevation: 8,
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${widget.subject.name}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Long Name: ${widget.subject.longName ?? 'Not Provided'}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Description: ${widget.subject.description ?? 'Not Provided'}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Teachers:',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<Teacher>>(
                      future: _filterTeachers(widget.subject.id!),
                      builder: (context, snapshot) {
                        if (_isLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (_errorMessage.isNotEmpty) {
                          return Center(
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Error: ${snapshot.error}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              'No teachers found for this subject.',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final filteredTeachers = snapshot.data!;
                        return ListView.builder(
                          itemCount: filteredTeachers.length,
                          itemBuilder: (context, index) {
                            final teacher = filteredTeachers[index];
                            return ListTile(
                              title: Text(
                                teacher.name.isNotEmpty
                                    ? teacher.name
                                    : 'No Name Provided',
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "Email: ${teacher.email ?? 'No Email Provided'}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
