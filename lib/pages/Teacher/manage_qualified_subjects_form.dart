import 'package:flutter/material.dart';

class ManageQualifiedSubjectsForm extends StatefulWidget {
  const ManageQualifiedSubjectsForm({super.key});

  @override
  _ManageQualifiedSubjectsFormState createState() =>
      _ManageQualifiedSubjectsFormState();
}

class _ManageQualifiedSubjectsFormState
    extends State<ManageQualifiedSubjectsForm> {
  // A static list of qualified subjects for the teacher
  final List<Map<String, String>> _qualifiedSubjects = [
    {"name": "Mathematics", "code": "MAT101"},
    {"name": "Physics", "code": "PHY102"},
    {"name": "Chemistry", "code": "CHE103"},
    {"name": "Biology", "code": "BIO104"},
    {"name": "Computer Science", "code": "CSE105"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subjects"),
        backgroundColor: const Color.fromARGB(
            255, 129, 77, 139), // Keeping the blue theme color
      ),
      body: Container(
        color: const Color.fromARGB(255, 31, 31, 31), // Light gray background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Qualified Subjects",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(
                      255, 215, 225, 255), // Dark blue text color
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Display the list of subjects using ListView.builder
              Expanded(
                child: ListView.builder(
                  itemCount: _qualifiedSubjects.length,
                  itemBuilder: (context, index) {
                    final subject = _qualifiedSubjects[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(
                          Icons.book,
                          color: Colors.blue, // Icon color to match theme
                        ),
                        title: Text(
                          subject['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF023E8A), // Text color
                          ),
                        ),
                        subtitle: Text(
                          "Code: ${subject['code'] ?? ''}",
                          style: const TextStyle(
                            fontSize: 16,
                            color:
                                Colors.black87, // Slightly lighter text color
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20), // Button to save changes, if n
            ],
          ),
        ),
      ),
    );
  }
}
