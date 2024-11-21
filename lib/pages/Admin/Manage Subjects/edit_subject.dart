import 'package:flutter/material.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class EditSubjectForm extends StatefulWidget {
  final Subject subject;

  const EditSubjectForm({Key? key, required this.subject}) : super(key: key);

  @override
  _EditSubjectFormState createState() => _EditSubjectFormState();
}

class _EditSubjectFormState extends State<EditSubjectForm> {
  late TextEditingController _nameController;
  late TextEditingController _longNameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject.name);
    _longNameController = TextEditingController(text: widget.subject.longName);
    _descriptionController = TextEditingController(text: widget.subject.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _longNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Function to handle saving the updated subject details
  void _saveChanges() {
    final updatedSubject = Subject(
      id: widget.subject.id,
      name: _nameController.text,
      longName: _longNameController.text,
      description: _descriptionController.text,
       
    );

    Navigator.pop(context, updatedSubject);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Edit Subject"),
        backgroundColor: AppColors.appBarColor,
      ),
      body: SingleChildScrollView(
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
            const SizedBox(height: 16),

            // Removed Teacher Selection (no longer needed)
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
