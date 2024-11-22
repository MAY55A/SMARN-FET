import 'package:flutter/material.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/subject_service.dart';

class EditSubjectForm extends StatefulWidget {
  final String subjectId;

  const EditSubjectForm({Key? key, required this.subjectId}) : super(key: key);

  @override
  _EditSubjectFormState createState() => _EditSubjectFormState();
}

class _EditSubjectFormState extends State<EditSubjectForm> {
  late TextEditingController _nameController;
  late TextEditingController _longNameController;
  late TextEditingController _descriptionController;
  final SubjectService _subjectService = SubjectService();

  bool _isLoading = true;
  Subject? _subject;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _longNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _fetchSubjectDetails();
  }

  Future<void> _fetchSubjectDetails() async {
    setState(() => _isLoading = true);

    try {
      // Use the service method to fetch subject details
      final subject = await _subjectService.getSubjectDetails(widget.subjectId);
      if (subject != null) {
        setState(() {
          _subject = subject;
          _nameController.text = subject.name;
          _longNameController.text = subject.longName!;
          _descriptionController.text = subject.description!;
        });
      } else {
        throw 'Subject not found';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load subject details: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _longNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Function to handle saving the updated subject details
  Future<void> _saveChanges() async {
    if (_subject == null) return;

    final updatedSubject = Subject(
      id: _subject!.id,
      name: _nameController.text.trim(),
      longName: _longNameController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    setState(() => _isLoading = true);

    try {
      // Use the service method to update subject
      final result =
          await _subjectService.updateSubject(updatedSubject.id!, updatedSubject);

      if (result['success']) {
        Navigator.pop(context, updatedSubject);
      } else {
        throw result['message'];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update subject: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Edit Subject"),
        backgroundColor: AppColors.appBarColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _subject == null
              ? const Center(child: Text('Subject not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name field
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Subject Name',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Long Name field
                      TextField(
                        controller: _longNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Subject Full Name',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description field
                      TextField(
                        controller: _descriptionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.appBarColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
