import 'package:flutter/material.dart';
import 'package:smarn/models/subject.dart';
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
  List<Map<String, String>> _teachers = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTeachersForSubject();
  }

  Future<void> _loadTeachersForSubject() async {
    try {
      var teachersList = await _teacherService.getTeachersBySubject(widget.subject.id!);

      if (teachersList.isNotEmpty) {
        setState(() {
          _teachers = teachersList;
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
        title: const Text("Subject Details", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600, // Set a max width for the card
            ),
            child: Card(
              color: Colors.grey[850], // Card background color
              elevation: 10, // Shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Padding inside the card
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Minimum space needed
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.subject.name ?? 'No name available',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20, // Font size for the name
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
                      "Long Name: ${widget.subject.longName ?? 'Not Provided'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Description: ${widget.subject.description ?? 'Not Provided'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Teachers:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                                          title: Text(teacher["name"]!,
                                              style: const TextStyle(color: Colors.white)),
                                          subtitle: Text(teacher["id"]!,
                                              style: const TextStyle(color: Colors.grey)),
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
