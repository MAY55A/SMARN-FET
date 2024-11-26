import 'package:flutter/material.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/teacher_service.dart';
import 'package:smarn/services/subject_service.dart';
import 'add_teacher_form.dart';
import 'edit_teacher_form.dart';

class ManageTeachersForm extends StatefulWidget {
  const ManageTeachersForm({super.key});

  @override
  _ManageTeachersFormState createState() => _ManageTeachersFormState();
}

class _ManageTeachersFormState extends State<ManageTeachersForm> {
  final TeacherService _teacherService = TeacherService();
  final SubjectService _subjectService = SubjectService();

  late Future<List<Map<String, dynamic>>> _teachersFuture;
  late Future<List<Subject>> _subjectsFuture;

<<<<<<< HEAD
  final TextEditingController _searchController = TextEditingController();
  String? _selectedSubject; // Initialize to null
=======
  TextEditingController _searchController = TextEditingController();
  String? _selectedSubject;
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81

  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _teachersFuture = _teacherService.getAllTeachers();
    _subjectsFuture = _subjectService.getAllSubjects();
    _subjectsFuture.then((subjects) {
      setState(() {
        _subjects = subjects;
      });
    });
  }

  Future<void> _refreshTeachers() async {
    setState(() {
<<<<<<< HEAD
      _teachersFuture =
          _teacherService.getAllTeachers(); // Refresh teacher list
=======
      _teachersFuture = _teacherService.getAllTeachers();
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
    });
  }

  String getSubjectNameById(String subjectId) {
    final subject = _subjects.firstWhere(
      (subject) => subject.id == subjectId,
      orElse: () => Subject(id: '', name: 'Unknown'),
    );
    return subject.name;
  }

  Future<List<Map<String, dynamic>>> _filterTeachers() async {
    if (_selectedSubject != null && _selectedSubject!.isNotEmpty) {
      return _teacherService.getTeachersBySubject(_selectedSubject!);
    } else {
      final allTeachers = await _teacherService.getAllTeachers();
      final searchTerm = _searchController.text.toLowerCase();

      return allTeachers.where((teacherData) {
        final teacher = teacherData['teacher'] as Teacher;
        final teacherName = teacher.name.toLowerCase() ?? '';
<<<<<<< HEAD
        return teacherName.contains(
            searchTerm); // Only filter by name if no subject is selected
=======
        return teacherName.contains(searchTerm);
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
      }).toList();
    }
  }

  Future<void> _confirmDeleteTeacher(String teacherId, String teacherName) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete $teacherName?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (shouldDelete ?? false) {
      final result = await _teacherService.deleteTeacher(teacherId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
        ),
      );

      if (result['success']) {
        _refreshTeachers();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Teachers"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Search bar
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Search by Name',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink),
                        ),
                        filled: true,
                        fillColor: Colors.black45,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Subject Dropdown
                  FutureBuilder<List<Subject>>(
                    future: _subjectsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text("Error fetching subjects");
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No subjects found.");
                      }

                      final subjects = snapshot.data!;
                      return DropdownButton<String>(
                        value: _selectedSubject,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSubject = newValue;
                          });
                        },
                        hint: const Text(
                          "Select Subject",
                          style: TextStyle(color: Colors.white),
                        ),
                        items: subjects
                            .map<DropdownMenuItem<String>>(
                              (subject) => DropdownMenuItem<String>(
<<<<<<< HEAD
                                value: subject
                                    .id, // Assuming each subject has an id
=======
                                value: subject.id,
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                                child: Text(
                                  subject.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList(),
                        dropdownColor: Colors.black45,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                // Fetch filtered teachers
                future: _filterTeachers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No teachers found."));
                  }

                  final teachersList = snapshot.data!;
                  return ListView.builder(
                    itemCount: teachersList.length,
                    itemBuilder: (context, index) {
                      final teacherData = teachersList[index];
                      final teacher = teacherData["teacher"] as Teacher;

                      final teacherName = teacher.name ?? 'No name provided';
                      final teacherEmail = teacher.email ?? 'No email provided';
                      final teacherPhone = teacher.phone ?? 'Not provided';
                      final teacherSubjects = teacher.subjects.isNotEmpty ==
                              true
                          ? teacher.subjects
                              .map((subjectId) => getSubjectNameById(subjectId))
                              .join(', ')
                          : 'No subjects available';

                      return Card(
                        color: Colors.grey[850],
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(teacherName,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Email: $teacherEmail",
                                  style: const TextStyle(color: Colors.white)),
                              Text("Phone: $teacherPhone",
                                  style: const TextStyle(color: Colors.white)),
                              Text("Subjects: $teacherSubjects",
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditTeacherForm(
                                          teacher: teacher,
                                          refreshTeachers: _refreshTeachers),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
<<<<<<< HEAD
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () async {
                                  // Implement delete teacher logic
                                },
=======
                                icon: const Icon(Icons.delete, color: Colors.white),
                                onPressed: () => _confirmDeleteTeacher(teacher.id!, teacherName),
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                              ),
                            ],
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddTeacherForm(refreshTeachers: _refreshTeachers),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        child: const Icon(Icons.add),
      ),
    );
  }
}
