import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/subject_service.dart';

class ViewTeacherDetailsForm extends StatefulWidget {
  final Teacher teacher;

  const ViewTeacherDetailsForm({Key? key, required this.teacher}) : super(key: key);

  @override
  _ViewTeacherDetailsFormState createState() => _ViewTeacherDetailsFormState();
}

class _ViewTeacherDetailsFormState extends State<ViewTeacherDetailsForm> {
  final SubjectService _subjectService = SubjectService();
  List<String> _subjectNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSubjectNames();
  }

  Future<void> _fetchSubjectNames() async {
    try {
      List<String> subjectNames = [];
      for (String subjectId in widget.teacher.subjects) {
        final subject = await _subjectService.getSubjectDetails(subjectId);
        if (subject != null && subject.longName != null) {
          subjectNames.add(subject.longName!);
        }
      }
      setState(() {
        _subjectNames = subjectNames;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background color
      appBar: AppBar(
        title: const Text("Teacher Details"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600), // Set a max width for the card
            child: Card(
              color: Colors.grey[850], // Card background color
              elevation: 10, // Shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Padding inside the card
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Teacher Information',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.white54,
                            thickness: 1,
                            height: 16,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Name: ${widget.teacher.name}',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Email: ${widget.teacher.email ?? 'Not Provided'}',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Phone: ${widget.teacher.phone ?? 'Not Provided'}',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Number of Hours: ${widget.teacher.nbHours ?? 'Not Provided'}',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: Colors.white54,
                            thickness: 1,
                            height: 16,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Subjects:',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          // ListView to display subjects in individual cards
                          Expanded(
                            child: ListView.builder(
                              itemCount: _subjectNames.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Card(
                                    color: Colors.white, // White card for each subject
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0), // Rounded corners for subjects
                                    ),
                                    elevation: 5, // Light shadow for the subject cards
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        _subjectNames[index],
                                        style: const TextStyle(color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
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
      ),
    );
  }
}
