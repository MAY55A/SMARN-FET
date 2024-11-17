import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/pages/widgets/canstants.dart'; // Ensure to have your constants file
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
  late Future<List<Teacher>?> _teachersFuture; 

  @override
  void initState() {
    super.initState();
    _teachersFuture = _teacherService.getTeachers(); // Fetch teachers
  }

  Future<void> _refreshTeachers() async {
    setState(() {
      _teachersFuture = _teacherService.getTeachers(); // Refresh teacher list
    });
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
        child: FutureBuilder<List<Teacher>?>( 
          future: _teachersFuture,
          builder: (context, snapshot) {
            // Check for loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text("No teachers found."));
            }

            final teachers = snapshot.data!;
            return ListView.builder(
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                final teacher = teachers[index];
                return Card(
                  color: AppColors.formColor,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(teacher.name ?? 'No name provided', style: const TextStyle(color: Colors.white)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${teacher.email ?? 'No email provided'}", style: const TextStyle(color: Colors.white)),
                        Text("Phone: ${teacher.phone ?? 'Not provided'}", style: const TextStyle(color: Colors.white)),
                        // Show subjects only if they're not null
                        Text("Subjects: ${teacher.subjects?.isNotEmpty == true ? teacher.subjects!.join(', ') : 'No subjects available'}", style: const TextStyle(color: Colors.white)),
                        // Show activities only if they're not null
                        Text("Activities: ${teacher.activities?.isNotEmpty == true ? teacher.activities!.join(', ') : 'No activities available'}", style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
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
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await _teacherService.deleteTeacherAccount(teacher.id!);
                              _refreshTeachers();
                            } catch (e) {
                              print("Error deleting teacher: $e");
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTeacherForm(
                refreshTeachers: _refreshTeachers,
              ),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        child: const Icon(Icons.add),
      ),
    );
  }
}
