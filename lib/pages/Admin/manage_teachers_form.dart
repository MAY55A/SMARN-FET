import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/teacher_service.dart';
import 'add_teacher_form.dart'; // Assuming you have this file
import 'edit_teacher_form.dart'; // Assuming you have this file

class ManageTeachersForm extends StatefulWidget {
  const ManageTeachersForm({Key? key}) : super(key: key);

  @override
  _ManageTeachersFormState createState() => _ManageTeachersFormState();
}

class _ManageTeachersFormState extends State<ManageTeachersForm> {
  final TeacherService _teacherService = TeacherService();
  late Future<List<Teacher>> _teachersFuture;

  @override
  void initState() {
    super.initState();
    _teachersFuture = _teacherService.getTeachers();
  }

  Future<void> _refreshTeachers() async {
    setState(() {
      _teachersFuture = _teacherService.getTeachers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Teachers"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add teacher page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTeacherForm(
                    refreshTeachers: _refreshTeachers,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 10, 19),
        child: FutureBuilder<List<Teacher>>(
          future: _teachersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No teachers found."));
            }

            final teachers = snapshot.data!;
            return ListView.builder(
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                final teacher = teachers[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(teacher.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${teacher.email}"),
                        Text("Phone: ${teacher.phone ?? 'Not provided'}"),
                        // Display subjects as a list
                        Text("Subjects: ${teacher.subjects.join(', ')}"),
                        // Display activities as a list
                        Text("Activities: ${teacher.activities.join(', ')}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to edit teacher page with teacher data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTeacherForm(
                                  teacher: teacher,
                                  refreshTeachers: _refreshTeachers,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              await _teacherService.deleteTeacher(teacher.id!); // Call the delete function
                              _refreshTeachers(); // Refresh the list after deletion
                            } catch (e) {
                              print("Error deleting teacher: $e");
                              // Optionally show an error message to the user
                            }
                          },
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
    );
  }
}
