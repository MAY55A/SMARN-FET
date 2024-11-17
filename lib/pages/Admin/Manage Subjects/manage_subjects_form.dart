import 'package:flutter/material.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'add_subject.dart';
import 'edit_subject.dart';

class ManageSubjectsForm extends StatefulWidget {
  const ManageSubjectsForm({Key? key}) : super(key: key);

  @override
  _ManageSubjectsFormState createState() => _ManageSubjectsFormState();
}

class _ManageSubjectsFormState extends State<ManageSubjectsForm> {
  List<Subject> subjects = [
    Subject(
      id: '1',
      name: 'Math',
      longName: 'Mathematics',
      description: 'Introduction to advanced mathematics.',
      teachers: [Teacher(name: 'Mr. John'), Teacher(name: 'Ms. Emily')],
    ),
    Subject(
      id: '2',
      name: 'Science',
      longName: 'Natural Science',
      description: 'Study of the physical and natural world.',
      teachers: [Teacher(name: 'Mrs. Smith')],
    ),
    // Add more sample subjects here...
  ];

  List<Subject> filteredSubjects = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredSubjects = subjects; // Initialize with all subjects
    _searchController.addListener(_filterSubjects);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterSubjects);
    _searchController.dispose();
    super.dispose();
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
        _filterSubjects(); // Update filtered list after adding
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
          _filterSubjects(); // Update filtered list after editing
        }
      });
    }
  }

  void _deleteSubject(Subject subject) {
    setState(() {
      subjects.remove(subject);
      _filterSubjects(); // Update filtered list after deletion
    });
    print("Deleted Subject: ${subject.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Subjects" ,style: TextStyle(color:Colors.white)),
        backgroundColor: AppColors.appBarColor,
      ),
      body: Container(
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
                  hintStyle: TextStyle(color:Colors.white),
                  prefixIcon: const Icon(Icons.search, color:Colors.white),
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
                        'Teachers: ${subject.teachers.map((t) => t.name).join(', ')}',
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
                            onPressed: () => _deleteSubject(subject),
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

class Subject {
  String? id;
  String name;
  String longName;
  String description;
  List<Teacher> teachers;

  Subject({
    this.id,
    required this.name,
    required this.longName,
    required this.description,
    required this.teachers,
  });
}

class Teacher {
  final String name;

  Teacher({required this.name});
}
