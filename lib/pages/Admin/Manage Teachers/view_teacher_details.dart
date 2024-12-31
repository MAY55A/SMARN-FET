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
        if (subject != null) {
          if (subject.longName != null) {
            subjectNames.add(subject.longName!);
          }
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
      appBar: AppBar(
        title: const Text("Teacher Details"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.grey[850], // Card color
            elevation: 8,
            child: SizedBox(
              width: 400, // Set a fixed width for the card
              height: 350, // Set a fixed height for the card
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Use minimum size for the column
                        children: [
                          Text('Name: ${widget.teacher.name}', style: const TextStyle(color: Colors.white, fontSize: 18)),
                          const SizedBox(height: 10),
                          Text('Email: ${widget.teacher.email ?? 'Not Provided'}', style: const TextStyle(color: Colors.white, fontSize: 18)),
                          const SizedBox(height: 10),
                          Text('Phone: ${widget.teacher.phone ?? 'Not Provided'}', style: const TextStyle(color: Colors.white, fontSize: 18)),
                          const SizedBox(height: 10),
                          Text('Number of Hours: ${widget.teacher.nbHours ?? 'Not Provided'}', style: const TextStyle(color: Colors.white, fontSize: 18)),
                          const SizedBox(height: 10),
                          Text('Subjects: ${_subjectNames.isNotEmpty ? _subjectNames.join(', ') : 'No subjects assigned'}',
                              style: const TextStyle(color: Colors.white, fontSize: 18)),
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
